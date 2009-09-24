import os
import yaml

class Controller:
	def __init__(self):
		pass

	def add_view(self,v):
		self.view = v

	def get_model(self):
		m = []
		for game in [ x for x in os.listdir("supported") \
			if len(x) >= 5 and x[-5:] == ".yaml"]:
				y = yaml.load(open("supported/%s"%game,"r").read())
				m.append(y)
				self.view.supported_game_added(y)
		return m

	def go(self):
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
		self.builder = gtk.Builder()
		self.builder.add_from_file("gdp.glade")
		self.window = self.builder.get_object("assistant1")
		self.window.connect("destroy", gtk.main_quit)

		treeview = self.builder.get_object("treeview1")
		cell = gtk.CellRendererText()
		column = gtk.TreeViewColumn('game')
		treeview.append_column(column)
		column.pack_start(cell, False)
		column.add_attribute(cell, "text", 0)
		treeview.connect("cursor-changed", self.game_row_selected)
		self.setup_second_page()

	def game_row_selected(self, treeview):
		c = treeview.get_cursor()
		if c:
			widget = self.window.get_nth_page(self.window.get_current_page())
			self.window.set_page_complete(widget, True)

	def setup_second_page(self):
		"""setup the assistant's second page. Assume that the first
		action for whatever game is selected, is a "install file"
		type one."""
		w = self.builder.get_object("placeholder_filechooser_window")
		children = w.get_children()
		print "there are %d children" % len(children)
		w.remove(children[0])
		self.window.append_page(children[0])
		print "zomg"

	def supported_game_added(self,game):
		liststor = self.builder.get_object("liststore1")
		liststor.append([game['longname']])

	def go(self):
		self.window.show()
		gtk.main()

if __name__ == "__main__":
	c = Controller()
	v = View(c)
	c.add_view(v)
	m = c.get_model()
	c.go()
