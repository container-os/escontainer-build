#!/bin/bash

# After mock 1.3.4, its implementation does not consider encoding well.
# So we may have UnicodeEncodeError problem if our locale is UTF-8 or something else.
# Our solution here is to force locale to be en_US and this is able to
# make our escore-build process more general on any other machines.
export LANG=en_US
