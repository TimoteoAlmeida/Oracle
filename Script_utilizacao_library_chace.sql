set pagesize 58
set linesize 150

column namespace format a20 heading 'Entity'
column pins format 999,999,999 heading 'Executions'
column pinhits format 999,999,999 heading 'Hits'
column pinhitratio format 9.99 heading 'Hit|Ratio'
column reloads format 999,999 heading 'Reloads'
column reloadratio format .9999 heading 'Reload|Ratio'
column invalidations format 999999999 heading 'Invalidations'

select namespace,
       pins,
       pinhits,
       pinhitratio,
       reloads,
       reloads / decode(pins, 0, 1, pins) reloadratio,
       invalidations
  from v$librarycache;