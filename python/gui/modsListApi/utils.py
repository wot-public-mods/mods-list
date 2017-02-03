
__all__ = ('byteify', 'override', )

def byteify(data):
	"""using for convert unicode key/value to utf-8"""
	if isinstance(data, dict):
		return {byteify(key): byteify(value) for key, value in data.iteritems()}
	elif isinstance(data, list):
		return [byteify(element) for element in data]
	elif isinstance(data, unicode):
		return data.encode('utf-8')
	else:
		return data

def overrider(function, module, method):
	"""classmethod override"""
	original = getattr(module, method)
	new_method = lambda *args, **kwargs: function(original, *args, **kwargs)
	if isinstance(original, property):
		setattr(module, method, property(new_method))
	else:
		setattr(module, method, new_method)
def decorator(function):
	def wrapper(*args, **kwargs):
		def decorate(handler):
			function(handler, *args, **kwargs)
		return decorate
	return wrapper

# override using for classmethods override
override = decorator(overrider)
