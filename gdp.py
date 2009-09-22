import os

class Controller:
	def __init__(self):
		pass
	def add_view(self,v):
		self.view = v
	def find_supported_games(self):
		for game in os.listdir("supported"):
			self.view.supported_game_added(game)
	def go(self):
			self.find_supported_games()
			self.view.go()

import sys
import gtk
import gtk.glade

class View:
	def __init__(self,c):
		self.controller = c
		try:
			gtk.init_check()
		except RuntimeError, e:
			sys.exit('E: %s. Exiting.' % e)
		gtk.gdk.threads_init()
		self.builder = gtk.Builder()
		self.builder.add_from_file("gdp.glade")
		self.builder.connect_signals({ "on_window_destroy" : gtk.main_quit })
		self.window = self.builder.get_object("window1")

		treeview = self.builder.get_object("treeview1")
		cell = gtk.CellRendererText()
		column = gtk.TreeViewColumn('game')
		treeview.append_column(column)
		column.pack_start(cell, False)
		column.add_attribute(cell, "text", 0)

	def supported_game_added(self,game):
		treeview = self.builder.get_object("treeview1")
		liststor = self.builder.get_object("liststore1")
		liststor.append([game])
	def go(self):
		self.window.show()
		gtk.main()

if __name__ == "__main__":
	c = Controller()
	v = View(c)
	c.add_view(v)
	c.go()
