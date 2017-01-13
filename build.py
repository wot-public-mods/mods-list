
import compileall
import os
import shutil
import zipfile


ANIMATE_PATH = 'C:\\Program Files\\Adobe\\Adobe Animate CC 2015\\Animate.exe'
GAME_VERSION = '0.9.17.0.2'
BUILD_RESMODS = True
BUILD_PACKAGE = True




# clean
if os.path.isdir('temp'):
	shutil.rmtree('temp')
os.mkdir('temp') 
if os.path.isdir('_build'):
	shutil.rmtree('_build')
os.mkdir('_build') 




# build flash
JSFL = ""
for file in os.listdir('as3'):
	if file.endswith('fla'):
		JSFL += 'fl.publishDocument("file:///{path}/as3/{file}", "Default");\r\n'.format(path = os.getcwd().replace('\\', '/').replace(':', '|'), file = file)
JSFL += 'fl.quit(false);'
with open('temp/build.jsfl', 'wb') as fh:
	fh.write(JSFL)
os.system('"{animate}" -e temp/build.jsfl'.format(animate = ANIMATE_PATH))
shutil.copytree('as3/bin/', 'temp/res_mods/{version}/gui/flash'.format(version = GAME_VERSION))
shutil.copytree('as3/bin/', 'temp/res/gui/flash')




# build python
for dirname, _, files in os.walk('python'):
	for filename in files:
		if filename.endswith(".py"):
			path = os.path.join(dirname, filename)
			compileall.compile_file(path)
			shutil.copytree('python', 'temp/res_mods/{version}/scripts/client/gui/mods/modsListApi'.format(version = GAME_VERSION), ignore=shutil.ignore_patterns('*.py'))
			shutil.copytree('python', 'temp/res/scripts/client/gui/mods/modsListApi', ignore=shutil.ignore_patterns('*.py'))




# build binaries
if BUILD_PACKAGE:
	zipobj = zipfile.ZipFile('_build/modsListApi' + '.wotmod', 'w', zipfile.ZIP_STORED)
	rootlen = len('temp/res') + 1
	for dirname, _, files in os.walk('temp/res'):
		for filename in files:
			path = os.path.join(dirname, filename)
			zipobj.write(path, 'res/' + path[rootlen:])
	with open('temp/res/meta.xml', 'wb') as fh:
		fh.write("<root>\r\n\t<!-- Techical MOD ID -->\r\n\t<id>{modID}</id>\r\n\t<!-- Package version -->\r\n\t<version>{version}</version>\r\n\t"\
				"<!-- Human readable name -->\r\n\t<name>{modName}</name>\r\n\t<!-- Human readable description -->\r\n\t"\
				"<description>{modDescription}</description>\r\n</root>".format(
			modID = "modsListApi",
			modName = "Modifications list",
			modDescription = "Modifications list: comfortable run, setup and alert",
			version = "1.0.0"
		))
	zipobj.write('temp/res/meta.xml', 'meta.xml')
	zipobj.close()

if BUILD_RESMODS:
	zipobj = zipfile.ZipFile('_build/modsListApi' + '.zip', 'w', zipfile.ZIP_DEFLATED)
	rootlen = len('temp/res_mods') + 1
	for dirname, _, files in os.walk('temp/res_mods'):
		for filename in files:
			path = os.path.join(dirname, filename)
			zipobj.write(path, 'res_mods/' + path[rootlen:])
	zipobj.close()
	
	
	
	
# clean
shutil.rmtree('temp')
for dirname, _, files in os.walk('.'):
	for filename in files:
		if filename.endswith('.swf') or filename.endswith('.pyc'):
			path = os.path.join(dirname, filename)
			os.remove(path)