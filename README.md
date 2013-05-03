# bmpdf

bmpdf is a Lua program that scripts a LaTeX implementation (tested with
XeLaTeX, LuaLaTeX, pdfLaTeX) to add bookmarks to PDF files. Bookmarks
are set to target specific pages, their names can be set to anything
which is allowed as normal text input by the TeX engine respectively
used.

This is a work in progress. Complete documentation will be provided
as soon as everything is functional.

# Dependencies

* Lua 5.2
* Penlight library
* lua-getopt library (written by me, see https://github.com/2ion/lua-getopt)

# License

For the full legal text, please refer to the LICENSE file.

```
bmpdf - use LaTeX and Lua to add arbitrary bookmarks to PDF files
Copyright (C) 2013 Jens Oliver John <asterisk@2ion.de>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
