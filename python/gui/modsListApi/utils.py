# SPDX-License-Identifier: MIT
# Copyright (c) 2015-2025 Andrii Andrushchyshyn

import functools
import logging
import os
import types

import ResMgr

from gui.shared.utils.functions import makeTooltip
from helpers import dependency
from skeletons.gui.impl import IGuiLoader

__all__ = ('byteify', 'override', 'vfs_file_read', 'vfs_dir_list_files', 'parse_localization_file', 
            'format_description', 'cache_result', 'get_logger', 'get_parent_window', )

def override(holder, name, wrapper=None, setter=None):
    """
    Overrides methods, properties, functions, and attributes.

    :param holder: The holder in which the target will be overridden.
    :param name: The name of the target to be overridden.
    :param wrapper: The replacement for the override target.
    :param setter: The replacement for the target property setter.
    """
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
    # type: (any) -> any
    """
    Encodes data with UTF-8.

    :param data: The data to encode.
    :return: The encoded data.
    """
    if isinstance(data, dict):
        return {byteify(key): byteify(value) for key, value in data.iteritems()}
    elif isinstance(data, (list, tuple, set)):
        return [byteify(element) for element in data]
    elif isinstance(data, unicode):
        return data.encode('utf-8')
    return data

def vfs_file_read(path):
    # type: (str) -> str | None
    """
    Reads a file from the VFS.

    :param path: The path to the file.
    :return: The file content as a string, or None if the file does not exist.
    """
    file_inst = ResMgr.openSection(path)
    if file_inst is not None and ResMgr.isFile(path):
        return str(file_inst.asBinary)
    return None

def vfs_dir_list_files(folder_path):
    # type: (str) -> list[str]
    """
    Lists files in a VFS directory.

    :param folder_path: The path to the directory.
    :return: A list of file names.
    """
    result = []
    folder = ResMgr.openSection(folder_path)
    if folder is not None and ResMgr.isDir(folder_path):
        for item_name in folder.keys():
            item_path = '%s/%s' % (folder_path, item_name)
            if item_name not in result and ResMgr.isFile(item_path):
                result.append(item_name)
    return result

def parse_localization_file(file_path):
    # type: (str) -> dict[str, str]
    """
    Parses a localization file in a YAML-like format.

    :param file_path: The path to the localization file.
    :return: A dictionary of localization keys and values.
    """
    result = {}
    file_data = vfs_file_read(file_path)
    if file_data:
        for test_line in file_data.splitlines():
            if ': ' not in test_line:
                continue
            key, value = test_line.split(': ', 1)
            result[key] = value.replace('\\n', '\n').strip()
    return result

def format_description(desc_text):
    # type: (str) -> str
    """
    Prepares a description for the `showComplex` tooltip.

    :param desc_text: The description text.
    :return: The prepared description.
    """
    if '{BODY}' not in desc_text:
        return makeTooltip(body=desc_text)
    return desc_text

def cache_result(function):
    # type: (callable) -> callable
    """
    A decorator to cache the result of a function.
    """
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

def get_parent_window():
    """
    Gets the main window of the application.
    """
    ui_loader = dependency.instance(IGuiLoader)
    if ui_loader and ui_loader.windowsManager:
        return ui_loader.windowsManager.getMainWindow()
    return None


def get_logger(name):
    # type: (str) -> logging.Logger
    """
    Gets a logger instance.

    :param name: The name of the logger.
    :return: A logger instance.
    """
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG if os.path.isfile('.debug_mods') else logging.ERROR)
    return logger
