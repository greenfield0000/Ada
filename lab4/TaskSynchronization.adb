with Barier;
use Barier;

procedure TaskSynchronization is
   b: tBarier ;
      
   task type tTask is
      entry Start(id: in integer; d: in float);
   end tTask;

   task body tTask is
      m_id: integer := -1;
      m_delay: float := 0.0;
   begin
      accept Start(id: in integer; d: in float) do
         m_id := id;
         m_delay := d;
      end;
            loop
               b.Arrive;
            end loop;
   end tTask;

   t1, t2, t3, t4: tTask;
begin
   Start(4);
   t1.Start(1, 0.01);
   t2.Start(2, 0.01);
   t3.Start(3, 0.01);
   t4.Start(4, 0.01);
end TaskSynchronization;