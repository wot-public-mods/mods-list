
from constants import DEFAULT_LANGUAGE
from helpers import getClientLanguage

from gui.modsListApi.modslist_constants import DEFAULT_UI_LANGUAGE

__all__ = ('l10n', )

_LANGUAGES = {
	"ru": { # русский
		'#title': 'Список модификаций',
		'#description': '{HEADER}Список модификаций{/HEADER}{BODY}Простой запуск и удобная настройка модификаций{/BODY}'
	},
	"uk": { # украинский
		'#title': 'Список модифікацій',
		'#description': '{HEADER}Список модифікацій{/HEADER}{BODY}Простий запуск і зручне налагодження модифікацій{/BODY}'
	},
	"be": { # белорусский
		'#title': 'Спіс мадыфікацый',
		'#description': '{HEADER}Спіс мадыфікацый{/HEADER}{BODY}Просты запуск і зручнае наладжванне мадыфікацый{/BODY}}'
	},
	"en": { # английский
		'#title': 'Modifications list',
		'#description': '{HEADER}Modifications list{/HEADER}{BODY}Simple launching and easy setup modifications{/BODY}'
	},
	"de": { # немецкий
		'#title': 'Mofikations Liste',
		'#description': '{HEADER}Modifikations Liste{/HEADER}{BODY}Nutzvoller start und einfache einrichtung modifikations{/BODY}'
	},
	"et": {}, # эстонский
	"bg": {}, # болгарский
	"da": {}, # датский
	"fi": {}, # финский
	"fil": {}, # филиппинский
	"fr": {}, # французский
	"el": {}, # греческий
	"hu": {}, # венгерский
	"id": {}, # индонезийский
	"it": {}, # италийский
	"ja": {}, # японский
	"ms": {}, # малайский
	"nl": {}, # нидерландский
	"no": {}, # норвежский
	"pl": {}, # польский
	"pt": {}, # португальский
	"pt_br": {}, # португальско-бразилийский
	"ro": {}, # румынский
	"sr": {}, # боснийский
	"vi": {}, # вьетнамский
	"zh_sg": {}, # китайский-сингапур
	"zh_tw": {}, # китайский-тайвань
	"hr": {}, # хорватский
	"th": {}, # тайский
	"lv": {}, # латишский
	"lt": {}, # литовский
	"cs": {}, # чешский
	"es_ar": {}, # испанский-аргентинский
	"tr": {}, # турецкий
	"zh_cn": {}, # китайский
	"es": {}, # испанский
	"kk": {}, # казахский
	"sv": {} # шведский
}

_CLIENT_LANGUAGE = getClientLanguage()
if _CLIENT_LANGUAGE in _LANGUAGES.keys():
	_LANGUAGE = _LANGUAGES[_CLIENT_LANGUAGE]
elif DEFAULT_LANGUAGE in _LANGUAGES.keys():
	_LANGUAGE = _LANGUAGES[DEFAULT_LANGUAGE]
else:
	_LANGUAGE = _LANGUAGES[DEFAULT_UI_LANGUAGE]

def l10n(key):
	"""returns localized value relative to key"""
	if key in _LANGUAGE:
		return _LANGUAGE[key]
	elif key in _LANGUAGES[DEFAULT_UI_LANGUAGE]:
		return _LANGUAGES[DEFAULT_UI_LANGUAGE][key]
	else:
		return key
	