#!/usr/bin/env python
# -*- coding: utf-8 -*-
import math
import pymysql
import tkinter as tk
from tkinter import ttk
from tkinter import font as tkfont
from tkinter import messagebox


class App(tk.Tk):
    """
    The Controller for the application.

    Controls current age and updates database data.
    """

    def __init__(self, *args, **kwargs):
        tk.Tk.__init__(self, *args, **kwargs)
        self.title('Tournament Manager')
        self.geometry('900x600')
        self.title_font = tkfont.Font(family='Helvetica', size=18, weight="bold", slant="italic")

        # The parent frame for all pages
        container = tk.Frame(self)
        container.pack(side="top", fill="both", expand=True)
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)
        self.container = container

        # The starting frame
        frame = LoginPage(parent=container, controller=self)
        frame.grid(row=0, column=0, sticky="nsew")
        self.frame = frame
        self.last_frame = None

        self.cnx = None
        self.t_id = None
        self.d_id = None
        self.t_id = None
        self.p_id = None
        self.s_id = None

    def next_frame(self, frame_type):
        self.last_frame = self.frame.__class__
        frame = frame_type(parent=self.container, controller=self)
        frame.grid(row=0, column=0, sticky="nsew")
        self.frame.destroy()
        self.frame = frame

    def refresh(self):
        self.next_frame(self.frame.__class__)

    def set_cnx(self, cnx):
        self.cnx = cnx

    def set_t_id(self, t_id):
        self.t_id = t_id

    def set_d_id(self, d_id):
        self.d_id = d_id

    def set_p_id(self, p_id):
        self.p_id = p_id

    def set_s_id(self, s_id):
        self.s_id = s_id


class LoginPage(ttk.Frame):
    """
    Represents the login page of the application.

    Takes user login input and validates login to SQL Database.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        # Form Grouping
        form = ttk.Frame(self)

        # username label and text entry box
        username_label = ttk.Label(form, text="Username")
        username_label.pack()
        self.username = tk.StringVar()
        username_entry = ttk.Entry(form, textvariable=self.username)
        username_entry.pack()

        # password label and password entry box
        password_label = ttk.Label(form, text="Password")
        password_label.pack()
        self.password = tk.StringVar()
        password_entry = ttk.Entry(form, textvariable=self.password, show='*')
        password_entry.pack()

        login_button = ttk.Button(form, text="Login", command=self.attempt_login)
        login_button.pack()

        form.place(relx=0.5, rely=0.4, anchor="center")

    def attempt_login(self):
        try:
            cnx = pymysql.connect(host='localhost', user=self.username.get(),
                                  password=self.password.get(),
                                  db='tm', charset='utf8mb4',
                                  cursorclass=pymysql.cursors.DictCursor)
            self.controller.set_cnx(cnx)
            self.controller.next_frame(Homepage)
        except pymysql.err.OperationalError as e:
            print('Error: %d: %s' % (e.args[0], e.args[1]))
            messagebox.showinfo("info", "Incorrect login info, please try again.")


class Homepage(ttk.Frame):
    """
    Represents the application homepage.

    Presents tournament/player access.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        label = ttk.Label(self, text="Homepage", font=controller.title_font)
        label.pack(side="top", fill="x", padx=10, pady=10)

        # Button Grouping
        group = ttk.Frame(self)

        button1 = ttk.Button(group, text="Go to Tournaments",
                             command=lambda: controller.next_frame(Tournaments))
        button1.pack()
        button2 = ttk.Button(group, text="Go to Players",
                             command=lambda: controller.next_frame(Players))
        button2.pack()
        button3 = ttk.Button(group, text="Go to Schools",
                             command=lambda: controller.next_frame(Schools))
        button3.pack()

        group.place(relx=0.5, rely=0.4, anchor="center")


class Header(ttk.Frame):
    """
    Represents a mainpage header.
    """

    def __init__(self, parent, controller, title):
        ttk.Frame.__init__(self, parent)

        title = ttk.Label(self, text=title, font=controller.title_font)
        title.pack(side="left")
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack(side="right")
        button = ttk.Button(self, text="Go back",
                            command=lambda: controller.next_frame(controller.last_frame))
        button.pack(side="right")


class Form(ttk.Frame):
    """
    Represents a form.
    """

    def __init__(self, parent, controller, table_name):
        ttk.Frame.__init__(self, parent)

        cur = controller.cnx.cursor()
        cur.callproc("get_columns_from_table", (table_name,))
        column_data = cur.fetchall()

        entries = {}
        for row in column_data:
            section = ttk.Frame(self)
            if row["COLUMN_KEY"] != "PRI":
                field = row["COLUMN_NAME"]
                datatype = row["DATA_TYPE"]
                label = ttk.Label(section, width=22, text=f"{field} ({datatype}): ", anchor='w')
                entry = ttk.Entry(section)
                section.pack(side=tk.TOP,
                             fill=tk.X,
                             padx=5,
                             pady=5)
                label.pack(side=tk.LEFT)
                entry.pack(side=tk.RIGHT,
                           expand=tk.YES,
                           fill=tk.X)
                entries[field] = entry
        self.entries = entries


class CreateForm(ttk.Frame):
    """
    Represents a create form.
    """

    def __init__(self, parent, controller, table_name):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        self.table_name = table_name

        form = Form(parent=self, controller=controller, table_name=table_name)
        form.pack()
        self.entries = form.entries

        button = ttk.Button(self, text=f"Create {table_name}",
                            command=lambda: self.create())
        button.pack()

    def create(self):
        columns = []
        values = []
        for field, entry in self.entries.items():
            columns.append(field)
            values.append(f"'{entry.get()}'")

        sql = f"INSERT INTO {self.table_name} ({', '.join(columns)}) VALUES ({', '.join(values)})"
        print(sql)

        try:
            cur = self.controller.cnx.cursor()
            cur.execute(sql)
            self.controller.cnx.commit()
            self.controller.refresh()
        except Exception as e:
            print(e)


class UpdateForm(ttk.Frame):
    """
    Represents an update form.
    """

    def __init__(self, parent, controller, table_name, entity_id):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        self.table_name = table_name
        self.entity_id = entity_id

        sql = f"SELECT * FROM {self.table_name} WHERE id={self.entity_id}"

        cur = self.controller.cnx.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        entity = rows[0]
        cur.close()

        form = Form(parent=self, controller=controller, table_name=table_name)
        form.pack()
        self.entries = form.entries

        for field, entry in self.entries.items():
            entry.insert(0, entity[field])

        button1 = ttk.Button(self, text=f"Update {table_name}",
                             command=lambda: self.update())
        button1.pack()
        button2 = ttk.Button(self, text=f"Delete {table_name}",
                             command=lambda: self.delete())
        button2.pack()

    def update(self):
        col_val_pairings = []
        for field, entry in self.entries.items():
            col_val_pairings.append(f"{field} = '{entry.get()}'")

        sql = f"UPDATE {self.table_name} SET {', '.join(col_val_pairings)} WHERE id={self.entity_id}"

        try:
            cur = self.controller.cnx.cursor()
            cur.execute(sql)
            self.controller.cnx.commit()
            cur.close()
            self.controller.refresh()
        except Exception as e:
            print(e)

    def delete(self):

        sql = f"DELETE FROM {self.table_name} WHERE id={self.entity_id}"

        try:
            cur = self.controller.cnx.cursor()
            cur.execute(sql)
            self.controller.cnx.commit()
            cur.close()
            self.controller.next_frame(self.controller.last_frame)
        except Exception as e:
            print(e)


class Tournaments(ttk.Frame):
    """
    Represents the tournaments view.

    Offers tournament creation and specific tournament selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        header = Header(parent=self, controller=controller, title="Tournaments")
        header.pack(fill="x", pady=10, padx=10)

        # Setup new tournament form
        create_tournament = CreateForm(parent=self, controller=controller, table_name="tournament")
        create_tournament.pack(fill="x", pady=10, padx=10)

        # Request all tournament information
        cur = controller.cnx.cursor()
        cur.callproc("view_all_tournaments")
        tournaments = cur.fetchall()
        cur.close()

        # Setup Tournament Grid
        tournament_grid = ttk.Frame(self)
        tournament_grid.grid_columnconfigure(0, weight=1)
        tournament_grid.grid_columnconfigure(1, weight=1)
        tournament_grid.grid_columnconfigure(2, weight=1)
        for y in range(math.ceil(len(tournaments) / 3)):
            tournament_grid.grid_rowconfigure(y, weight=1)

        # Add tournaments to grid
        count = 0
        for tournament in tournaments:
            name = tournament["name"]
            date = tournament["date"]
            address = tournament["address"]
            button_text = f"{name}\n" \
                          f"{date}\n" \
                          f"{address}"
            button = ttk.Button(tournament_grid, text=button_text,
                                command=lambda t_id=tournament["id"]: self.select_tournament(t_id))
            button.grid(row=math.trunc(count / 3), column=count % 3, sticky="nsew")
            count += 1

        tournament_grid.pack(fill="both", expand=True, pady=10, padx=10)

    def select_tournament(self, t_id):
        self.controller.set_t_id(t_id)
        self.controller.next_frame(Tournament)


class Tournament(ttk.Frame):
    """
    Represents a specific tournament view.

    Presents tournament data, offers tournament deletion/editing, and division selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        header = Header(parent=self, controller=controller, title=f"Tournament {controller.t_id}")
        header.pack(fill="x", pady=10, padx=10)

        # Setup new tournament form
        update_tournament = \
            UpdateForm(parent=self, controller=controller, table_name="tournament", entity_id=controller.t_id)
        update_tournament.pack(fill="x", pady=10, padx=10)

        # Request tournament's divisions
        cur = controller.cnx.cursor()
        cur.callproc("view_all_tournament_divisions", (controller.t_id,))
        divisions = cur.fetchall()
        cur.close()

        division_grid = ttk.Frame(self)
        division_grid.grid_columnconfigure(0, weight=1)
        division_grid.grid_columnconfigure(1, weight=1)
        division_grid.grid_columnconfigure(2, weight=1)
        for y in range(math.ceil(len(divisions) / 3)):
            division_grid.grid_rowconfigure(y, weight=1)

        count = 0
        for division in divisions:
            name = division["name"]
            button_text = f"{name}\n"
            button = ttk.Button(division_grid, text=button_text,
                                command=lambda d_id=division["id"]: self.select_division(d_id))
            button.grid(row=math.trunc(count / 3), column=count % 3, sticky="nsew")
            count += 1
        division_grid.pack(fill="both", expand=True, pady=10, padx=10)

        # Setup new division form
        create_division = CreateForm(parent=self, controller=controller, table_name="division")
        create_division.pack(fill="x", pady=10, padx=10)
        create_division.entries["tournament_id_FK"].insert(0, controller.t_id)
        create_division.entries["tournament_id_FK"].config(state="disabled")

    def select_division(self, d_id):
        self.controller.set_d_id(d_id)
        self.controller.next_frame(Division)


# TBD
class Division(ttk.Frame):
    """
    Represents a specific division view.

    Presents division data and offers player deletion/editing.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        cur = self.controller.cnx.cursor()
        cur.callproc("view_specific_division", (self.controller.div_id,))
        rows = cur.fetchall()
        cur.close()
        used_row = rows[0]

        header = Header(parent=self, controller=controller, title=used_row["name"])
        header.pack(fill="x", pady=10, padx=10)

        # Iterators through each aspect of the call and creates a label for it
        col = 0
        for key in used_row.keys():
            tmp_label = ttk.Label(self, text=str(key) + ": " + str(used_row[key]))

            # Change this to .grid() later
            tmp_label.pack()
            col += 1


class Players(ttk.Frame):
    """
    Represents the players view.

    Offers player creation and specific player selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        label = ttk.Label(self, text="Players", font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()

        cur = controller.cnx.cursor()
        cur.callproc("view_all_players")
        rows = cur.fetchall()
        players = {}
        for row in rows:
            players[row["id"]] = row
        cur.close()

        for p_id in players:
            name = players[p_id]["name"]
            date_of_birth = players[p_id]["dob"]
            phone_number = players[p_id]["phone_number"]
            button_text = f"{name}\n" \
                          f"{date_of_birth}\n" \
                          f"{phone_number}"
            button = ttk.Button(self, text=button_text,
                                command=lambda p=p_id: self.select_player(p_id))
            button.pack()

    def select_player(self, p_id):

        self.controller.set_p_id(p_id)
        self.controller.next_frame(Player)


class Player(ttk.Frame):
    """
    Represents a specific player view.

    Presents player data and offers player deletion/editing.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        cur = self.controller.cnx.cursor()
        cur.callproc("view_specific_player", (self.controller.p_id,))
        row = cur.fetchall()
        cur.close()

        used_row = row[0]
        # Iterators through each aspect of the call and creates a label for it
        col = 0
        for key in used_row.keys():
            tmp_label = ttk.Label(self, text=str(key) + ": " + str(used_row[key]))

            # Change this to .grid() later
            tmp_label.pack()
            col += 1

        label = ttk.Label(self, text=used_row["name"], font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()


class Schools(ttk.Frame):
    """
    Represents the schools view.

    Offers school creation and specific school selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        label = ttk.Label(self, text="Schools", font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()

        # Add all the buttons needed
        cur = controller.cnx.cursor()
        cur.callproc("view_all_schools")
        rows = cur.fetchall()
        schools = {}
        for row in rows:
            schools[row["id"]] = row
        cur.close()

        for school_id in schools:
            name = schools[school_id]["name"]
            address = schools[school_id]["address"]
            button_text = f"{name}\n" \
                          f"{address}\n"
            button = ttk.Button(self, text=button_text,
                                command=lambda s=school_id: self.select_school(school_id))
            button.pack()

    def select_school(self, school_id):

        self.controller.set_school_id(school_id)
        self.controller.next_frame(School)


class School(ttk.Frame):
    """
    Represents a specific tournament view.

    Presents tournament data, offers tournament deletion/editing, and division selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller

        cur = self.controller.cnx.cursor()
        cur.callproc("view_specific_school", (self.controller.school_id,))
        row = cur.fetchall()
        cur.close()

        used_row = row[0]
        # Iterators through each aspect of the call and creates a label for it
        col = 0
        for key in used_row.keys():
            tmp_label = ttk.Label(self, text=str(key) + ": " + str(used_row[key]))

            # Change this to .grid() later
            tmp_label.pack()
            col += 1

        label = ttk.Label(self, text=used_row["name"], font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()


if __name__ == "__main__":
    app = App()
    app.mainloop()
