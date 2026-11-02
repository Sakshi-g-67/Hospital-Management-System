"""Hospital Management System - Modern UI (CustomTkinter) + MySQL
Reads your tables automatically and saves everything to the database.
 
Install:  pip install customtkinter mysql-connector-python
Run:      python hospital_modern.py
"""
import re
import tkinter as tk
from tkinter import ttk, messagebox
 
import customtkinter as ctk
import mysql.connector
from mysql.connector import Error
 
# ------------ DATABASE DETAILS ------------
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "root",
    "database": "hospital_management",
}
# ------------------------------------------
 
BLUE = "#1d4ed8"
BLUE_DARK = "#1e40af"
SIDEBAR = "#0f172a"
SIDEBAR_HOVER = "#1e293b"
BG = "#f1f5f9"
CARD_COLORS = ["#2563eb", "#0d9488", "#7c3aed", "#ea580c", "#db2777", "#0891b2", "#65a30d", "#dc2626"]
 
ctk.set_appearance_mode("light")
ctk.set_default_color_theme("blue")
 
 
# ---------------- database helpers ----------------
def s(v):
    return v.decode() if isinstance(v, (bytes, bytearray)) else v
 
 
def run(sql, params=None, fetch=False):
    conn = mysql.connector.connect(**DB_CONFIG)
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        if fetch:
            return [d[0] for d in cur.description], cur.fetchall()
        conn.commit()
        return cur.rowcount
    finally:
        conn.close()
 
 
def q(name):
    return "`" + name.replace("`", "``") + "`"
 
 
def pretty(name):
    return name.replace("_", " ").title()
 
 
def icon(name):
    n = name.lower()
    for key, ic in [("patie", "🧑"), ("doctor", "👨‍⚕️"), ("appoint", "📅"), ("bill", "💳"),
                    ("depart", "🏢"), ("medic", "💊"), ("admis", "🛏️"), ("audit", "📝"),
                    ("staff", "👥"), ("nurse", "👩‍⚕️"), ("room", "🚪"), ("ward", "🏥")]:
        if key in n:
            return ic
    return "📋"
 
 
def get_columns(table):
    cols, rows = run(f"SHOW COLUMNS FROM {q(table)}", fetch=True)
    return [{k: s(v) for k, v in zip(cols, r)} for r in rows]
 
 
def get_foreign_keys(table):
    _, rows = run(
        "SELECT COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME "
        "FROM information_schema.KEY_COLUMN_USAGE "
        "WHERE TABLE_SCHEMA=%s AND TABLE_NAME=%s AND REFERENCED_TABLE_NAME IS NOT NULL",
        (DB_CONFIG["database"], table), fetch=True)
    return {s(r[0]): (s(r[1]), s(r[2])) for r in rows}
 
 
def fk_options(ref_table, ref_col):
    """Dropdown options like '3 - Dr. Mehta' for a foreign key column."""
    cols = get_columns(ref_table)
    label = next((c["Field"] for c in cols if c["Key"] != "PRI" and
                  ("char" in c["Type"].lower() or "text" in c["Type"].lower())), None)
    if label:
        _, rows = run(f"SELECT {q(ref_col)}, {q(label)} FROM {q(ref_table)} LIMIT 500", fetch=True)
        return [f"{r[0]} - {r[1]}" for r in rows]
    _, rows = run(f"SELECT {q(ref_col)} FROM {q(ref_table)} LIMIT 500", fetch=True)
    return [str(r[0]) for r in rows]
 
 
# ---------------- entry form ----------------
class FormDialog(ctk.CTkToplevel):
    def __init__(self, parent, title, columns, fks, values, on_save):
        super().__init__(parent)
        self.title(title)
        self.geometry(f"500x{min(200 + 78 * len(columns), 740)}")
        self.configure(fg_color="white")
        self.transient(parent)
        self.after(150, self.grab_set)
        self.on_save = on_save
        self.fields = {}
 
        ctk.CTkLabel(self, text=title, font=ctk.CTkFont("Segoe UI", 20, "bold"),
                     text_color=BLUE).pack(pady=(18, 4))
        ctk.CTkLabel(self, text="Fields marked * are required", text_color="gray50",
                     font=ctk.CTkFont("Segoe UI", 12)).pack()
 
        body = ctk.CTkScrollableFrame(self, fg_color="transparent")
        body.pack(fill="both", expand=True, padx=24, pady=8)
 
        for col in columns:
            name, ctype = col["Field"], col["Type"].lower()
            required = col["Null"] == "NO" and col["Default"] is None
            ctk.CTkLabel(body, text=pretty(name) + (" *" if required else ""), anchor="w",
                         font=ctk.CTkFont("Segoe UI", 13, "bold")).pack(fill="x", pady=(8, 2))
            cur = values.get(name)
 
            if name in fks:
                opts = fk_options(*fks[name])
                w = ctk.CTkComboBox(body, values=opts or [""], height=36)
                w.set("")
                if cur is not None:
                    w.set(next((o for o in opts if o.split(" - ")[0] == str(cur)), str(cur)))
                kind = "fk"
            elif ctype.startswith("enum("):
                opts = re.findall(r"'([^']*)'", col["Type"])
                w = ctk.CTkComboBox(body, values=opts, height=36)
                w.set(str(cur) if cur is not None else "")
                kind = "plain"
            else:
                if ctype.startswith("datetime") or ctype.startswith("timestamp"):
                    ph = "YYYY-MM-DD HH:MM:SS"
                elif ctype.startswith("date"):
                    ph = "YYYY-MM-DD"
                elif ctype.startswith("time"):
                    ph = "HH:MM:SS"
                else:
                    ph = f"Enter {pretty(name).lower()}"
                w = ctk.CTkEntry(body, height=36, placeholder_text=ph)
                if cur is not None:
                    w.insert(0, str(cur))
                kind = "plain"
            w.pack(fill="x")
            self.fields[name] = (w, kind)
 
        btns = ctk.CTkFrame(self, fg_color="transparent")
        btns.pack(pady=14)
        ctk.CTkButton(btns, text="💾  Save", width=140, height=38, command=self.save,
                      font=ctk.CTkFont("Segoe UI", 14, "bold")).pack(side="left", padx=8)
        ctk.CTkButton(btns, text="Cancel", width=110, height=38, fg_color="gray60",
                      hover_color="gray45", command=self.destroy).pack(side="left", padx=8)
 
    def collect(self):
        data = {}
        for name, (w, kind) in self.fields.items():
            v = w.get().strip()
            if kind == "fk" and " - " in v:
                v = v.split(" - ")[0].strip()
            data[name] = v
        return data
 
    def save(self):
        if self.on_save(self.collect()):
            self.destroy()
 
 
# ---------------- main app ----------------
class HospitalApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("MediCare - Hospital Management System")
        self.geometry("1280x720")
        self.minsize(1000, 600)
        self.configure(fg_color=BG)
 
        try:
            _, rows = run("SHOW TABLES", fetch=True)
        except Error as e:
            messagebox.showerror("Connection failed",
                                 f"Could not connect to MySQL.\n\n{e}\n\nCheck DB_CONFIG at the top of the file.")
            self.destroy()
            return
        self.tables = [s(r[0]) for r in rows]
        self.nav_buttons = {}
        self.table = None
        self.columns, self.fks, self.rows = [], {}, []
 
        self.setup_tree_style()
        self.build_sidebar()
        self.main = ctk.CTkFrame(self, fg_color=BG, corner_radius=0)
        self.main.pack(side="left", fill="both", expand=True)
        self.show_dashboard()
 
    # ----- styling -----
    def setup_tree_style(self):
        st = ttk.Style()
        st.theme_use("clam")
        st.configure("Treeview", rowheight=34, font=("Segoe UI", 11), background="white",
                     fieldbackground="white", foreground="#1f2937", borderwidth=0)
        st.configure("Treeview.Heading", font=("Segoe UI", 11, "bold"), background=BLUE,
                     foreground="white", relief="flat", padding=8)
        st.map("Treeview", background=[("selected", "#bfdbfe")], foreground=[("selected", "#111827")])
        st.map("Treeview.Heading", background=[("active", BLUE_DARK)])
 
    # ----- sidebar -----
    def build_sidebar(self):
        sb = ctk.CTkFrame(self, width=240, fg_color=SIDEBAR, corner_radius=0)
        sb.pack(side="left", fill="y")
        sb.pack_propagate(False)
 
        ctk.CTkLabel(sb, text="🏥  MediCare", font=ctk.CTkFont("Segoe UI", 24, "bold"),
                     text_color="white").pack(pady=(26, 2))
        ctk.CTkLabel(sb, text="Hospital Management", font=ctk.CTkFont("Segoe UI", 12),
                     text_color="#94a3b8").pack(pady=(0, 18))
 
        self.nav_buttons["__dash__"] = self.nav_button(sb, "🏠   Dashboard", self.show_dashboard)
 
        scroll = ctk.CTkScrollableFrame(sb, fg_color="transparent")
        scroll.pack(fill="both", expand=True, pady=6)
        for t in self.tables:
            self.nav_buttons[t] = self.nav_button(scroll, f"{icon(t)}   {pretty(t)}",
                                                  lambda t=t: self.show_table(t))
 
        ctk.CTkLabel(sb, text=f"● Connected: {DB_CONFIG['database']}", text_color="#4ade80",
                     font=ctk.CTkFont("Segoe UI", 11)).pack(pady=12)
 
    def nav_button(self, parent, text, command):
        b = ctk.CTkButton(parent, text=text, anchor="w", height=40, corner_radius=8,
                          fg_color="transparent", hover_color=SIDEBAR_HOVER, text_color="white",
                          font=ctk.CTkFont("Segoe UI", 14), command=command)
        b.pack(fill="x", padx=12, pady=2)
        return b
 
    def highlight(self, key):
        for k, b in self.nav_buttons.items():
            b.configure(fg_color=BLUE if k == key else "transparent")
 
    def clear_main(self):
        for w in self.main.winfo_children():
            w.destroy()
 
    # ----- dashboard -----
    def show_dashboard(self):
        self.highlight("__dash__")
        self.clear_main()
        ctk.CTkLabel(self.main, text="Dashboard", font=ctk.CTkFont("Segoe UI", 28, "bold"),
                     text_color="#0f172a").pack(anchor="w", padx=30, pady=(26, 0))
        ctk.CTkLabel(self.main, text="Click a card to open that section", text_color="gray45",
                     font=ctk.CTkFont("Segoe UI", 13)).pack(anchor="w", padx=30, pady=(0, 16))
 
        grid = ctk.CTkFrame(self.main, fg_color="transparent")
        grid.pack(fill="both", expand=True, padx=24)
        for i, t in enumerate(self.tables):
            try:
                count = run(f"SELECT COUNT(*) FROM {q(t)}", fetch=True)[1][0][0]
            except Error:
                count = "-"
            card = ctk.CTkButton(
                grid, text=f"{icon(t)}\n\n{count}\n{pretty(t)}", width=210, height=140,
                corner_radius=16, fg_color=CARD_COLORS[i % len(CARD_COLORS)],
                hover_color=BLUE_DARK, text_color="white",
                font=ctk.CTkFont("Segoe UI", 17, "bold"), command=lambda t=t: self.show_table(t))
            card.grid(row=i // 4, column=i % 4, padx=10, pady=10)
 
    # ----- table page -----
    def show_table(self, table):
        self.table = table
        self.highlight(table)
        self.clear_main()
        try:
            self.columns = get_columns(table)
            self.fks = get_foreign_keys(table)
        except Error as e:
            messagebox.showerror("Error", str(e))
            return
 
        head = ctk.CTkFrame(self.main, fg_color="transparent")
        head.pack(fill="x", padx=30, pady=(24, 10))
        ctk.CTkLabel(head, text=f"{icon(table)}  {pretty(table)}",
                     font=ctk.CTkFont("Segoe UI", 26, "bold"), text_color="#0f172a").pack(side="left")
        ctk.CTkButton(head, text="＋  Add New", height=40, width=130,
                      font=ctk.CTkFont("Segoe UI", 14, "bold"),
                      command=self.add_record).pack(side="right")
 
        bar = ctk.CTkFrame(self.main, fg_color="transparent")
        bar.pack(fill="x", padx=30, pady=(0, 10))
        self.search_entry = ctk.CTkEntry(bar, width=300, height=38, placeholder_text="🔍  Search records...")
        self.search_entry.pack(side="left")
        self.search_entry.bind("<Return>", lambda e: self.load_data())
        ctk.CTkButton(bar, text="Search", width=90, height=38, command=self.load_data).pack(side="left", padx=8)
        ctk.CTkButton(bar, text="Reset", width=80, height=38, fg_color="gray60", hover_color="gray45",
                      command=self.reset_search).pack(side="left")
        self.count_label = ctk.CTkLabel(bar, text="", text_color="gray40")
        self.count_label.pack(side="right")
 
        wrap = tk.Frame(self.main, bg="white")
        wrap.pack(fill="both", expand=True, padx=30)
        names = [c["Field"] for c in self.columns]
        self.tree = ttk.Treeview(wrap, columns=names, show="headings", selectmode="browse")
        ysb = ttk.Scrollbar(wrap, orient="vertical", command=self.tree.yview)
        xsb = ttk.Scrollbar(wrap, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=ysb.set, xscrollcommand=xsb.set)
        for n in names:
            self.tree.heading(n, text=pretty(n))
            self.tree.column(n, width=140, minwidth=90, anchor="w")
        self.tree.tag_configure("odd", background="#f1f5f9")
        self.tree.grid(row=0, column=0, sticky="nsew")
        ysb.grid(row=0, column=1, sticky="ns")
        xsb.grid(row=1, column=0, sticky="ew")
        wrap.rowconfigure(0, weight=1)
        wrap.columnconfigure(0, weight=1)
        self.tree.bind("<Double-1>", lambda e: self.edit_record())
 
        actions = ctk.CTkFrame(self.main, fg_color="transparent")
        actions.pack(fill="x", padx=30, pady=14)
        ctk.CTkButton(actions, text="✏️  Edit", width=110, height=38, fg_color="#0d9488",
                      hover_color="#0f766e", command=self.edit_record).pack(side="left", padx=(0, 8))
        ctk.CTkButton(actions, text="🗑️  Delete", width=110, height=38, fg_color="#dc2626",
                      hover_color="#b91c1c", command=self.delete_record).pack(side="left", padx=(0, 8))
        ctk.CTkButton(actions, text="🔄  Refresh", width=110, height=38, fg_color="gray55",
                      hover_color="gray40", command=self.load_data).pack(side="left")
 
        self.load_data()
 
    def reset_search(self):
        self.search_entry.delete(0, "end")
        self.load_data()
 
    def load_data(self):
        sql = f"SELECT * FROM {q(self.table)}"
        params = []
        term = self.search_entry.get().strip()
        if term:
            sql += " WHERE " + " OR ".join(f"CAST({q(c['Field'])} AS CHAR) LIKE %s" for c in self.columns)
            params = [f"%{term}%"] * len(self.columns)
        sql += " LIMIT 1000"
        try:
            _, self.rows = run(sql, params, fetch=True)
        except Error as e:
            messagebox.showerror("Database error", str(e))
            return
        self.tree.delete(*self.tree.get_children())
        for i, row in enumerate(self.rows):
            self.tree.insert("", "end", iid=str(i), tags=("odd",) if i % 2 else (),
                             values=["" if v is None else v for v in row])
        self.count_label.configure(text=f"{len(self.rows)} record(s)")
 
    def selected_row(self):
        sel = self.tree.selection()
        if not sel:
            messagebox.showinfo("Select a row", "Please click a row in the table first.")
            return None
        return dict(zip([c["Field"] for c in self.columns], self.rows[int(sel[0])]))
 
    def pk_columns(self):
        return [c["Field"] for c in self.columns if c["Key"] == "PRI"]
 
    # ----- add / edit / delete (saved to MySQL) -----
    def add_record(self):
        editable = [c for c in self.columns
                    if "auto_increment" not in c["Extra"].lower() and "generated" not in c["Extra"].lower()]
 
        def save(data):
            fields, vals = [], []
            for c in editable:
                v = data[c["Field"]]
                if v == "":
                    if c["Null"] == "NO" and c["Default"] is None:
                        messagebox.showwarning("Required", f"'{pretty(c['Field'])}' is required.")
                        return False
                    continue
                fields.append(q(c["Field"]))
                vals.append(v)
            if not fields:
                messagebox.showwarning("Empty", "Please fill in the form.")
                return False
            sql = (f"INSERT INTO {q(self.table)} ({', '.join(fields)}) "
                   f"VALUES ({', '.join(['%s'] * len(fields))})")
            try:
                run(sql, vals)
            except Error as e:
                messagebox.showerror("Could not save", str(e))
                return False
            self.load_data()
            messagebox.showinfo("Success", "✅ Record saved to the database.")
            return True
 
        FormDialog(self, f"Add {pretty(self.table)}", editable, self.fks, {}, save)
 
    def edit_record(self):
        old = self.selected_row()
        if old is None:
            return
        pks = self.pk_columns()
        if not pks:
            messagebox.showwarning("No primary key", "This table has no primary key, so it cannot be edited safely.")
            return
        editable = [c for c in self.columns if "generated" not in c["Extra"].lower()]
 
        def save(data):
            sets, vals = [], []
            for c in editable:
                v = data[c["Field"]]
                if v == "" and c["Null"] == "NO" and c["Default"] is None:
                    messagebox.showwarning("Required", f"'{pretty(c['Field'])}' is required.")
                    return False
                sets.append(f"{q(c['Field'])} = %s")
                vals.append(None if v == "" else v)
            where = " AND ".join(f"{q(p)} = %s" for p in pks)
            vals += [old[p] for p in pks]
            try:
                run(f"UPDATE {q(self.table)} SET {', '.join(sets)} WHERE {where}", vals)
            except Error as e:
                messagebox.showerror("Could not update", str(e))
                return False
            self.load_data()
            messagebox.showinfo("Success", "✅ Record updated.")
            return True
 
        FormDialog(self, f"Edit {pretty(self.table)}", editable, self.fks, old, save)
 
    def delete_record(self):
        old = self.selected_row()
        if old is None:
            return
        pks = self.pk_columns()
        if not pks:
            messagebox.showwarning("No primary key", "This table has no primary key, so rows cannot be deleted safely.")
            return
        if not messagebox.askyesno("Confirm delete", "Delete the selected record permanently?"):
            return
        where = " AND ".join(f"{q(p)} = %s" for p in pks)
        try:
            run(f"DELETE FROM {q(self.table)} WHERE {where}", [old[p] for p in pks])
        except Error as e:
            messagebox.showerror("Could not delete",
                                 f"{e}\n\nThis record may be used by another table (foreign key).")
            return
        self.load_data()
 
 
if __name__ == "__main__":
    HospitalApp().mainloop()
 