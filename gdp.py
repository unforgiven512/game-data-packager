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
		self.setup_gtkbuilder()
		self.setup_gamechooser_page()

	def setup_gtkbuilder(self):
		self.builder = gtk.Builder()
		self.builder.add_from_file("gdp.glade")
		self.window = self.builder.get_object("assistant1")
		self.window.connect("destroy", gtk.main_quit)
		self.window.connect("cancel", gtk.main_quit)

	def setup_gamechooser_page(self):
		treeview = self.builder.get_object("treeview1")
		cell = gtk.CellRendererText()
		column = gtk.TreeViewColumn('game')
		treeview.append_column(column)
		column.pack_start(cell, False)
		column.add_attribute(cell, "text", 0)
		treeview.connect("cursor-changed", lambda treeview:
			treeview.get_cursor() and \
				self.window.set_page_complete(
					self.window.get_nth_page(self.window.get_current_page()),
					True))
		self.setup_filechooser_page()

	def setup_filechooser_page(self):
		"""setup the assistant's second page. Assume that the first
		action for whatever game is selected, is a "install file"
		type one."""
		w = self.builder.get_object("placeholder_filechooser_window")
		children = w.get_children()
		w.remove(children[0])
		w = self.window
		w.append_page(children[0])
		self.builder.get_object("choose_file_button").connect("clicked", 
			self.handle_file_button)
		self.builder.get_object("choose_file_entry").connect("changed",
			lambda e: w.set_page_complete( w.get_nth_page(w.get_current_page()), True))

	def handle_file_button(self,button):
		chooser = gtk.FileChooserDialog(title="Select doom2.wad", 
			action=gtk.FILE_CHOOSER_ACTION_OPEN,
			buttons=(gtk.STOCK_CANCEL,gtk.RESPONSE_CANCEL,gtk.STOCK_OPEN,
				gtk.RESPONSE_OK))
		chooser.run()
		self.builder.get_object("choose_file_entry").set_text(chooser.get_filename())
		chooser.destroy()

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
