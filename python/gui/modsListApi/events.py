# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

import Event

__all__ = ('g_eventsManager', )

class EventsManager(object):

	def __init__(self):
		self.onListUpdated = Event.Event()
		self.invokeModification = Event.Event()
		self.showPopover = Event.Event()

g_eventsManager = EventsManager()
