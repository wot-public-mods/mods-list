
import functools
import types
import ResMgr
from gui.shared.utils.functions import makeTooltip
from helpers import dependency
from skeletons.gui.impl import IGuiLoader

__all__ = ('byteify', 'override', 'readFromVFS', 'parse_lang_fields', 'prepareDescription', 'cache_result')

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

def readFromVFS(path):
	"""using for read files from VFS"""
	fileInst = ResMgr.openSection(path)
	if fileInst is not None and ResMgr.isFile(path):
		return str(fileInst.asBinary)
	return None

def parse_lang_fields(langFile):
	"""split items by lines and key value by ':'
	like yaml format"""
	result = {}
	langData = readFromVFS(langFile)
	if langData:
		for item in langData.splitlines():
			if ': ' not in item:
				continue
			key, value = item.split(": ", 1)
			result[key] = value.replace('\\n', '\n')
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
