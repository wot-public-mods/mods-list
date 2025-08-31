# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

import functools
import logging
import os
import ResMgr
import types
from gui.shared.utils.functions import makeTooltip
from helpers import dependency
from skeletons.gui.impl import IGuiLoader

__all__ = ('byteify', 'override', 'vfs_file_read', 'vfs_dir_list_files', 'parse_localization_file', 
			'prepareDescription', 'cache_result', 'getLogger', )

def override(holder, name, wrapper=None, setter=None):
	"""Override methods, properties, functions, attributes
	:param holder: holder in which target will be overrided
	:param name: name of target to be overriden
	:param wrapper: replacement for override target
	:param setter: replacement for target property setter"""
	if wrapper is None:
		return lambda wrapper, setter=None: override(holder, name, wrapper, setter)
	target = getattr(holder, name)
	wrapped = lambda *a, **kw: wrapper(target, *a, **kw)
	if not isinstance(holder, types.ModuleType) and isinstance(target, types.FunctionType):
		setattr(holder, name, staticmethod(wrapped))
	elif isinstance(target, property):
		prop_getter = lambda *a, **kw: wrapper(target.fget, *a, **kw)
		prop_setter = target.fset if not setter else lambda *a, **kw: setter(target.fset, *a, **kw)
		setattr(holder, name, property(prop_getter, prop_setter, target.fdel))
	else:
		setattr(holder, name, wrapped)

def byteify(data):
	"""Encodes data with UTF-8
	:param data: Data to encode"""
	result = data
	if isinstance(data, dict):
		result = {byteify(key): byteify(value) for key, value in data.iteritems()}
	elif isinstance(data, (list, tuple, set)):
		result = [byteify(element) for element in data]
	elif isinstance(data, unicode):
		result = data.encode('utf-8')
	return result

def vfs_file_read(path):
	"""using for read files from VFS"""
	fileInst = ResMgr.openSection(path)
	if fileInst is not None and ResMgr.isFile(path):
		return str(fileInst.asBinary)
	return None

def vfs_dir_list_files(folder_path):
	"""using for list files in VFS dir"""
	result = []
	folder = ResMgr.openSection(folder_path)
	if folder is not None and ResMgr.isDir(folder_path):
		for item_name in folder.keys():
			item_path = '%s/%s' % (folder_path, item_name)
			if item_name not in result and ResMgr.isFile(item_path):
				result.append(item_name)
	return result

def parse_localization_file(file_path):
	"""split items by lines and key value by ':'
	like yaml format"""
	result = {}
	file_data = vfs_file_read(file_path)
	if file_data:
		for test_line in file_data.splitlines():
			if ': ' not in test_line:
				continue
			key, value = test_line.split(': ', 1)
			result[key] = value.replace('\\n', '\n').strip()
	return result

def prepareDescription(descText):
	"""prepere Description for showComplex"""
	if '{BODY}' not in descText:
		return makeTooltip(body=descText)
	return descText

def cache_result(function):
	memo = {}
	@functools.wraps(function)
	def wrapper(*args):
		try:
			return memo[args]
		except KeyError:
			rv = function(*args)
			memo[args] = rv
			return rv
	return wrapper

def getParentWindow():
	uiLoader = dependency.instance(IGuiLoader)
	if uiLoader and uiLoader.windowsManager:
		return uiLoader.windowsManager.getMainWindow()

def getLogger(name):
	logger = logging.getLogger(name)
	logger.setLevel(logging.DEBUG if os.path.isfile('.debug_mods') else logging.ERROR)
	return logger
