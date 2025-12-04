-- filename: show_queue.sql

set echo on 
select count(*) from DBA_AQ_AGENTS ;
select count(*) from DBA_AQ_AGENT_PRIVS ;
select count(*) from DBA_QUEUE_PUBLISHERS  ;

select count(*) from DBA_QUEUE_TABLES ;
select count(*) from SYS.AQ$_PENDING_MESSAGES ;
select count(*) from SYS.AQ$_PROPAGATION_STATUS ;
select count(*) from DBA_QUEUES ;

select OWNER, NAME, ENQUEUE_ENABLED, DEQUEUE_ENABLED
from DBA_QUEUES 
order by 1,2 ;

set echo off