
__all__ = ('byteify', 'override', 'readFromVFS', 'parseLangFields', 'prepereDescription')

import types
import ResMgr
from gui.shared.utils.functions import makeTooltip

def overrider(target, holder, name):
	"""override any staff"""
	original = getattr(holder, name)
	overrided = lambda *a, **kw: target(original, *a, **kw)
	if not isinstance(holder, types.ModuleType) and isinstance(original, types.FunctionType):
		setattr(holder, name, staticmethod(overrided))
	elif isinstance(original, property):
		setattr(holder, name, property(overrided))
	else:
		setattr(holder, name, overrided)
def decorator(function):
	def wrapper(*args, **kwargs):
		def decorate(handler):
			function(handler, *args, **kwargs)
		return decorate
	return wrapper
override = decorator(overrider)

def byteify(data):
	"""convert dict unicode key/value to utf-8"""
	result = data
	if isinstance(data, types.DictType):
		result = {byteify(key): byteify(value) for key, value in data.iteritems()}
	elif isinstance(data, (types.ListType, tuple, set)):
		result = [byteify(element) for element in data]
	elif isinstance(data, types.UnicodeType):
		result = data.encode('utf-8')
	return result

def readFromVFS(path):
	"""using for read files from VFS"""
	fileInst = ResMgr.openSection(path)
	if fileInst is not None and ResMgr.isFile(path):
		return str(fileInst.asBinary)
	return None

def parseLangFields(langFile):
	"""split items by lines and key value by ':'
	like yaml format"""
	result = {}
	langData = readFromVFS(langFile)
	if langData:
		for item in langData.splitlines():
			if ': ' not in item:
				continue
			key, value = item.split(": ", 1)
			result[key] = value
	return result

def prepereDescription(descText):
	"""prepere Description for showComplex"""
	if '{HEADER}' and '{BODY}' not in descText:
		return makeTooltip(body=descText)
	return descText
