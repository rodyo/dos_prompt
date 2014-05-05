@echo off

if %#==0 explorer .
if not %#==0 explorer "%*"
