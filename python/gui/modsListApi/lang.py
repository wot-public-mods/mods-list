# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2026 Andrii Andrushchyshyn

from helpers import getClientLanguage

from ._constants import LANGUAGE_DEFAULT, LANGUAGE_FALLBACK, LANGUAGE_FILES
from .utils import cache_result, parse_localization_file, vfs_dir_list_files

class Localization(object):
    """
    A class to handle localization.
    """

    def __init__(self, locale_folder, default=LANGUAGE_DEFAULT, fallback=LANGUAGE_FALLBACK):
        # type: (str, str, dict) -> None
        """
        Initializes the localization class.

        :param locale_folder: The folder containing the localization files.
        :param default: The default language.
        :param fallback: A dictionary of fallback languages.
        """
        # All available languages
        self.languages = {}
        for file_name in vfs_dir_list_files(locale_folder):
            if not file_name.endswith('.yml'):
                continue
            file_path = '%s/%s' % (locale_folder, file_name)
            lang_data = parse_localization_file(file_path)
            if lang_data:
                lang_code = file_name.replace('.yml', '')
                self.languages[lang_code] = lang_data

        # Default language
        self._ui_default = default

        # Client language (with fallback)
        client_language = getClientLanguage()
        self._client_default = default
        if client_language in fallback:
            self._client_default = fallback[0]

        # Use the most suitable language
        self.language = {}
        if client_language in self.languages:
            self.language = self.languages[client_language]
        elif self._client_default in self.languages:
            self.language = self.languages[self._client_default]
        else:
            self.language = self.languages.get(self._ui_default, {})

    @cache_result
    def __call__(self, locale_key):
        # type: (str) -> str
        """
        Gets the localized string for the given key.

        :param locale_key: The key to localize.
        :return: The localized string.
        """
        if locale_key in self.language:
            return self.language[locale_key]
        elif locale_key in self.languages[self._client_default]:
            return self.languages[self._client_default][locale_key]
        elif locale_key in self.languages[self._ui_default]:
            return self.languages[self._ui_default][locale_key]
        return locale_key

    @cache_result
    def get_sentences(self):
        # type: () -> dict
        """
        Gets a dictionary of all localized strings.
        """
        result = {}
        for k, v in self.languages[self._ui_default].items():
            result[k] = v
        for k, v in self.languages[self._client_default].items():
            result[k] = v
        for k, v in self.language.items():
            result[k] = v
        return result

l10n = Localization(LANGUAGE_FILES)
