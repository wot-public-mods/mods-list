
import compileall
import datetime
import os
import shutil
import zipfile

ANIMATE_PATH = 'C:\\Program Files\\Adobe\\Adobe Animate CC 2015\\Animate.exe'
MODIFICATION_VERSION = '1.0.0'
GAME_VERSION = '0.9.17.0.2'
BUILD_RESMODS = True
BUILD_PACKAGE = True

# use this bcs shutil.copytree sometimes throw error on folders create
def copytree(source, destination, ignore=None):
	for item in os.listdir(source):
		sourcePath = os.path.join(source, item)
		destinationPath = os.path.join(destination, item)
		if os.path.isfile(sourcePath):
			baseDir, fileName = os.path.split(destinationPath)
			if not os.path.isdir(baseDir):
				os.makedirs(baseDir)
			if ignore:
				ignored_names = ignore(source, os.listdir(source))
				if fileName in ignored_names:
					continue
			shutil.copy2(sourcePath, destinationPath)
		else:
			copytree(sourcePath, destinationPath, ignore)

# use this bcs zipfile by default dont create folders info in result zip
def zipFolder(source, destination, mode='w', compression=zipfile.ZIP_STORED):
	now = tuple(datetime.datetime.now().timetuple())[:6]
	zip = zipfile.ZipFile(destination, mode, compression)
	for dirname, _, files in os.walk(source):
		zi = zipfile.ZipInfo(dirname, now)
		zi.filename = zi.filename.replace(source, "")
		if len(zi.filename):
			if not zi.filename.endswith('/'): 
				zi.filename += '/'
			if zi.filename.startswith('/'): 
				zi.filename = zi.filename[1:]
			zi.compress_type = compression
			zip.writestr(zi, '')
		for filename in files:
			path = os.path.join(dirname, filename)
			st = os.stat(path)
			zi = zipfile.ZipInfo(path, now)
			zi.external_attr = 2176188416L
			zi.filename = zi.filename.replace(source, "")
			if zi.filename.startswith('/'): 
				zi.filename = zi.filename[1:]
			zi.compress_type = compression
			zip.writestr(zi, open(path, 'rb').read())
	zip.close()


# clean up
if os.path.isdir('temp'):
	shutil.rmtree('temp')
os.mkdir('temp') 
if os.path.isdir('build'):
	shutil.rmtree('build')
os.mkdir('build') 


# build flash
with open('temp/build.jsfl', 'wb') as fh:
	for fileName in os.listdir('as3'):
		if fileName.endswith('fla'):
			fh.write('fl.publishDocument("file:///{path}/as3/{fileName}", "Default");\r\n'.format(path = os.getcwd().replace('\\', '/').replace(':', '|'), fileName = fileName))
	fh.write('fl.quit(false);')
os.system('"{animate}" -e temp/build.jsfl'.format(animate = ANIMATE_PATH))


# build python
for dirName, _, files in os.walk('python'):
	for fileName in files:
		if fileName.endswith(".py"):
			filePath = os.path.join(dirName, fileName)
			compileall.compile_file(filePath)


# copy all staff
copytree('resources', 'temp/standart/res_mods/{version}'.format(version = GAME_VERSION))
copytree('resources', 'temp/wgpackage/res')
copytree('as3/bin/', 'temp/standart/res_mods/{version}/gui/flash'.format(version = GAME_VERSION))
copytree('as3/bin/', 'temp/wgpackage/res/gui/flash')
copytree('python', 'temp/standart/res_mods/{version}/scripts/client/gui/mods/modsListApi'.format(version = GAME_VERSION), ignore=shutil.ignore_patterns('*.py'))
copytree('python', 'temp/wgpackage/res/scripts/client/gui/mods/modsListApi', ignore=shutil.ignore_patterns('*.py'))


# build binaries

META = """<root>
	<!-- Techical MOD ID -->
	<id>{modID}</id>
	<!-- Package version -->
	<version>{version}</version>
	<!-- Human readable name -->
	<name>{modName}</name>
	<!-- Human readable description -->
	<description>{modDescription}</description>
</root>"""

if BUILD_PACKAGE:
	with open('temp/wgpackage/meta.xml', 'wb') as fh:
		fh.write(
			META.format(
				modID = "modsListApi",
				modName = "Modifications list",
				modDescription = "Modifications list: comfortable run, setup and alert",
				version = MODIFICATION_VERSION
			)
		)
	zipFolder('temp/wgpackage', 'build/modsListApi.wotmod')

if BUILD_RESMODS:
	zipFolder('temp/standart', 'build/modsListApi.zip', compression=zipfile.ZIP_DEFLATED)
	
	
	
# clean up
shutil.rmtree('temp')
for dirname, _, files in os.walk('.'):
	for filename in files:
		if filename.endswith('.swf') or filename.endswith('.pyc'):
			path = os.path.join(dirname, filename)
			os.remove(path)