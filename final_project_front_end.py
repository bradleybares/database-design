#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pymysql
import tkinter as tk
from tkinter import ttk
from tkinter import font as tkfont
from tkinter import messagebox


class SampleApp(tk.Tk):
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

        self.cnx = None
        self.t_id = None
        self.div_id = None
        self.team_id = None

    def next_frame(self, frame_type):
        frame = frame_type(parent=self.container, controller=self)
        frame.grid(row=0, column=0, sticky="nsew")
        self.frame.destroy()
        self.frame = frame

    def set_cnx(self, cnx):
        self.cnx = cnx

    def set_t_id(self, t_id):
        self.t_id = t_id


class LoginPage(ttk.Frame):
    """
    Represents the login page of the application.

    Takes user login input and validates login to SQL Database.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        label = ttk.Label(self, text="Login Here", font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)

        # username label and text entry box
        username_label = ttk.Label(self, text="Username")
        username_label.pack()
        self.username = tk.StringVar()
        username_entry = ttk.Entry(self, textvariable=self.username)
        username_entry.pack()

        # password label and password entry box
        password_label = ttk.Label(self, text="Password")
        password_label.pack()
        self.password = tk.StringVar()
        password_entry = ttk.Entry(self, textvariable=self.password, show='*')
        password_entry.pack()

        login_button = ttk.Button(self, text="Login", command=self.attempt_login)
        login_button.pack()

    def attempt_login(self):
        try:
            cnx = pymysql.connect(host='localhost', user=self.username.get(),
                                  password=self.password.get(),
                                  db='tm', charset='utf8mb4',
                                  cursorclass=pymysql.cursors.DictCursor)
            self.controller.set_cnx(cnx)
            self.controller.next_frame(Homepage)
        except Exception as e:
            print(e)
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
        label.pack(side="top", fill="x", pady=10)

        button1 = ttk.Button(self, text="Go to Tournaments",
                             command=lambda: controller.next_frame(Tournaments))
        button1.pack()
        button2 = ttk.Button(self, text="Go to Players",
                             command=lambda: controller.next_frame(Players))
        button2.pack()
        button3 = ttk.Button(self, text="Go to Players",
                             command=lambda: controller.next_frame(Schools))
        button3.pack()


class Tournaments(ttk.Frame):
    """
    Represents the tournaments view.

    Offers tournament creation and specific tournament selection.
    """

    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        label = ttk.Label(self, text="Tournaments", font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()

        cur = controller.cnx.cursor()
        cur.callproc("view_all_tournaments")
        rows = cur.fetchall()
        tournaments = {}
        for row in rows:
            tournaments[row["tournament_id"]] = row["tourn_name"]
        cur.close()

        for t_id in tournaments:
            button = ttk.Button(self, text=tournaments[t_id],
                                command=lambda: self.select_tournament(t_id))
            button.pack()

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

        cur = self.controller.cnx.cursor()
        cur.callproc("view_specific_tournament", (self.controller.t_id,))
        row = cur.fetchall()
        cur.close()

        label = ttk.Label(self, text=row[0]["tourn_name"], font=controller.title_font)
        label.pack(side="top", fill="x", pady=10)
        button = ttk.Button(self, text="Go to the homepage",
                            command=lambda: controller.next_frame(Homepage))
        button.pack()


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


if __name__ == "__main__":
    app = SampleApp()
    app.mainloop()
