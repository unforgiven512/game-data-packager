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

class FilePicker(gtk.VBox):
	def __init__(self,name):
		gtk.VBox.__init__(self)
		label = gtk.Label("Please locate the file '%s'." % name)
		self.pack_start(label)
		hbox = gtk.HBox()
		self.entry = entry = gtk.Entry()
		entry.connect("changed", lambda e: \
			w.set_page_complete( w.get_nth_page(w.get_current_page()), True))
		hbox.pack_start(gtk.Label("Filename: "), expand=False)
		hbox.pack_start(entry)
		button = gtk.Button("Select File...")
		button.connect("clicked", self.handle_file_button)
		hbox.pack_start(button, expand=False)
		self.pack_start(hbox, expand=False)

	def handle_file_button(self,button):
		chooser = gtk.FileChooserDialog(title="Select doom2.wad", 
			action=gtk.FILE_CHOOSER_ACTION_OPEN,
			buttons=(gtk.STOCK_CANCEL,gtk.RESPONSE_CANCEL,gtk.STOCK_OPEN,
				gtk.RESPONSE_OK))
		chooser.run()
		self.entry.set_text(chooser.get_filename())
		chooser.destroy()

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
		self.window.set_forward_page_func(self.forward_page_func, None)
		self.window.set_page_title(self.window.get_nth_page(0),"Game Data Packager")
		def setup_dummy_page():
			"""unfortunately necessary due to the way we abuse forward_page_func"""
			self.b = gtk.Button("YOU SHOULD NOT SEE THIS")
			self.window.append_page(self.b)
		setup_dummy_page()

	# XXX: this gets called as soon as a page is marked as completed.
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
			fp = FilePicker(na['name'])
			fp.show_all()
			self.window.insert_page(fp, self.window.get_n_pages() - 1)
			self.window.set_page_title(
				self.window.get_nth_page(self.window.get_n_pages() - 2),
				"File '%s'" % na['name'])
		else: # XXX: validation should live elsewhere
			print "not a recognised action type :("
		return current_page + 1

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
