project('ValaTutorials', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    meson.get_compiler('vala').find_library('posix')
]

executable('HelloWorld', 'src/hello/HelloWorld.vala', dependencies: dependencies)
executable('HelloObjectWorld', 'src/hello/HelloObjectWorld.vala', dependencies: dependencies)
executable('HelloGUIWorld', 'src/hello/HelloGUIWorld.vala', dependencies: dependencies)

executable('nullability', 'src/hello/nullability.vala', dependencies: dependencies)

executable('lock', 'src/threading/lock.vala', dependencies: dependencies)

executable('ntp', 'src/examples/ntp.vala', dependencies: dependencies)