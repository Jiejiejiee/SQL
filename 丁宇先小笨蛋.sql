select empiid
from mpi_demographicinfo
where empiid in
      (select empiid
       from ehr_healthRecord a
       where not exists (select 1
                         from INC_IncompleteRecord b
                         where a.empiid = b.empiid
                           and to_char(b.createDate, 'yyyy') = 2023)
         and manaunitid like '361002148%');

select empiid
from mpi_demographicinfo
where empiid = "";

select empiid
from (select empiid
      from ehr_healthRecord a
      where not exists (select 1
                        from INC_IncompleteRecord b
                        where a.empiid = b.empiid
                          and to_char(b.createDate, 'yyyy') = 2023)
        and manaunitid like '361002148%')
where empiid = "";

