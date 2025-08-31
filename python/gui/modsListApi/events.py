# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

import Event

class EventsManager(object):
    """
    Manages custom events for the ModsList API.
    """

    def __init__(self):
        # type: () -> None
        """
        Initializes the event manager.
        """
        self.onListUpdated = Event.Event()
        self.invokeModification = Event.Event()
        self.showPopover = Event.Event()

g_eventsManager = EventsManager()
