#!/usr/bin/env lua5.2
-- bmpdf - use LaTeX and Lua to add arbitrary bookmarks to PDF files
-- Copyright (C) 2013 Jens Oliver John <asterisk@2ion.de>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

math.randomseed(os.time())
local function print(t)
    io.stderr:write(string.format(unpack(t)) .. "\n")
end
local file = require("pl.file")
local path = require("pl.path")
local tx = require("pl.tablex")
local getopt = require("getopt")
local cfg = {
    engine = "pdflatex",
    pdfinput = io.input(),
    pdfoutput = io.output(),
    btable = nil
}
local optspec = {
    { a = { "o", "output" }, g = 1, f = function (v)
            local v = v[1]
            if v == "-" then 
                cfg.pdfoutput = io.output()
            elseif path.exists(v) then
                error("Error: output file exists!")
            else
                cfg.pdfoutput = v
            end
        end
    },

    { a = { "i", "input" }, g = 1, f = function (v)
            local v = v[1]
            if v == "-" then 
                cfg.pdfinput = io.input()
            elseif not (path.exists(v) and path.isfile(v)) then
                error("Error: input file doesn't exist or is not a regular file!")
            else
                cfg.pdfinput = v
            end
        end
    },

    { a = { "b", "bookmarks" }, g = 1, f = function (v)
            local v = v[1]
            cfg.btable = require(v)
        end
    },

    { a = { "X", "xelatex" },   f = function () cfg.engine = "xelatex" end },
    { a = { "P", "pdflatex" },  f = function () cfg.engine = "pdflatex" end },
    { a = { "L", "lualatex" },  f = function () cfg.engine = "lualatex" end }
}

local function random_string()
    local s = ""
    for i=1,5 do
        s = s .. string.char(math.random(65,90))
    end
    return s
end

local function to_tex(t, pdffile)
    local s = ""
    local function append(target, level, name)
        local htarget = random_string()
        s = s .. string.format("\\includepdf[pages=%d,pagecommand={\\thispagestyle{empty}\\hypertarget{%s}{}}]{%s}\n", target, htarget, pdffile)
        s = s .. string.format("\\bookmark[dest={%s},level=%d]{%s}\n", htarget, level, name)
    end
    local function dive(t, l)
        for i,j in ipairs(t) do
            append(j.target, l , j.name)
            if j.root then dive(j.root, l + 1) end
        end
    end
    dive(t, 0)
    return s
end

local function print_latex(document)
    return string.format([[
\documentclass{article}
\usepackage[utf8x]{inputenc}
\usepackage{hyperref,bookmark,pdfpages}
\begin{document}
%s\end{document}]], document)
end

-- local doc = to_tex({ { target=1, name="Erste Seite" }, { target=2, name="Zweite Seite" } }, "pdfdatei.pdf")

local function caseof(v, t)
    for k,v in pairs(t) do
        if v == k then
            t[k]()
        end
    end
end

-- And magic happens

local noop = getopt(optspec)

if #noop ~= 0 then
    printf{"All non-option arguments will be ignored."}
end

if not cfg.btable then
    error("Error: no bookmark data available. Load some data using the -b option.")
end


