#!/bin/sh
plackup -MPlack::App::Directory -e 'Plack::App::Directory->new(root=>".");' -p 8000
