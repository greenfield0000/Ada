package body Barier is
   protected body tBarier is
      entry Arrive when not release_threads and threads_number > 0 is begin
         threads := threads + 1;
                  if (threads < threads_number) then
            requeue Go;
         else
            threads := threads - 1;
                      --  PUT("    !!!!");
            release_threads := true;
         end if;
      end Arrive;
      
      entry Go when release_threads is begin
         threads := threads - 1;
         if (threads = 0) then
            release_threads := false;
         end if;
      end Go;
   end tBarier;
      
      procedure Start(N: in integer) is 
      begin
         threads_number := N;
      end Start;
end Barier;
