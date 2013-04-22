#!/usr/bin/env lua5.2
-- bmpdf - use pdfTeX to set bookmarks in a PDF file
-- Copyright (C) 2013 Jens Oliver John
-- Licensed under the GNU General Public License v3.

local file = require("pl.file")
math.randomseed(os.time())

local function random_string()
    local s = ""
    for i=1,20 do
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

local doc = to_tex({ { target=1, name="Erste Seite" }, { target=2, name="Zweite Seite" } }, "pdfdatei.pdf")
print(print_latex(doc))
