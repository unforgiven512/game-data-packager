import os
import yaml

class Model(list):
	def __init__(self):
		self.active_item = -1

	def set_active_item(self,item):
		self.active_item = item

class Controller:
	def __init__(self):
		pass

	def add_view(self,v):
		self.view = v

	def get_model(self):
		self.m = m = Model()
		for game in [ x for x in os.listdir("supported")]:
			y = yaml.load(open("supported/%s"%game,"r").read())
			m.append(y)
			self.view.supported_game_added(y)
		return m

	def set_game(self, game):
		self.m.set_active_item(game)

	def get_next_action(self):
		"""return the next action required for the selected game.
		   currently we do not handle dependencies: the actions will
		   need to be specified in the precise order they are required
		   to be satisfied."""
		actions = self.m[self.m.active_item]['actions']
		actions = filter(lambda x: not x.has_key('complete'), actions)
		return actions[0]

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
		treeview.connect("row-activated", lambda treeview,path,col:
			self.window.set_current_page(self.window.get_current_page()+1))
		self.setup_filechooser_page()
		self.window.set_forward_page_func(self.forward_page_func, None)

	def forward_page_func(self, current_page, data):
		if 0 == current_page:
			# XXX: bug. active row not reported properly if keyboard nav used
			treeview = self.builder.get_object("treeview1")
			path,col = treeview.get_cursor()
			self.controller.set_game(path[0])
		na = self.controller.get_next_action()
		if na.has_key('type') and "copy" == na['type']:
			# TODO: setup the next page, a file copy page.
			print na
		else: # XXX: validation should live elsewhere
			print "not a recognised action type :("
		return current_page + 1

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
