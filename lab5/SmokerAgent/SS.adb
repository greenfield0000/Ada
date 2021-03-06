with Ada.Text_Io;
use Ada.Text_Io;
with Ada.Calendar;
use Ada.Calendar;
with Ada.Numerics.Float_Random;

package body Ss is
   
   -- ������ ���������
   SIZE_GENERATION: INTEGER := 100;
   -- ����� ���������
   COUNT_GENERATION: INTEGER := 0;
   -- ����� ������ ���������   
   FIX_START_TIME: Duration;
   
   Arr   : Comp_Arr := (Paper, Tabacco, Match);  
   Table : Tdeck;  
   Agent : Tagent;  
   -- for file
   Myfile : Ada.Text_Io.File_Type;  
   
   type Ttime is array (1 .. 4, 1 .. SIZE_GENERATION) of Duration;
   type TGenerate is array (1 .. SIZE_GENERATION) of INTEGER;
   
   IntimeRequest, OuttimeResponse, InTimeGenerate, 
      OutTimeGenerate, InWaitAgent, OutWaitAgent,
      InWaitSmoker, OutWaitSmoker: Ttime;  
   IsGenerated: TGenerate;
   -- include Randomize;
   package Rnd renames Ada.Numerics.Float_Random;
   Gen : Rnd.Generator;  

   function Pick_Random (
         A : Comp_Arr ) 
     return Components is 
   begin
      return A(A'First + Natural(Rnd.Random(Gen) * Float(A'Last)));
   end Pick_Random;

   procedure clearMassiveGenerate is
   begin
      for i in 1..SIZE_GENERATION loop
         IsGenerated(i) := 0;
      end loop;
   
   end clearMassiveGenerate;

   task body Tsmoker is
      Comp1,  
      Comp2 : Components;  
   begin
     -- loop
        for I in Integer range 1 .. SIZE_GENERATION loop
           if (Component = Paper) then
             Comp1 := Tabacco;
             Comp2 := Match;
           end if;
           if (Component = Tabacco) then
             Comp1 := Paper;
             Comp2 := Match;
           end if;
           if (Component = Match) then
             Comp1 := Tabacco;
             Comp2 := Paper;
           end if;
            
            InWaitSmoker(Id, I) := Seconds(Clock);
            IntimeRequest(Id, I) := Seconds(Clock);
            Table.Give(Comp1,Comp2);
            OuttimeResponse(Id, I) := Seconds(Clock);
            OutWaitSmoker(Id, I) := Seconds(Clock); 

         end loop; 
--       end loop;
   
         Open(File => MyFile, Mode => Append_File, Name => "Log.txt");
         for j in integer range 1 .. 3 loop
            Put(File => MyFile, Item => "Smoker");
            Put(File => MyFile, Item => Integer'Image(j));
            New_Line(File => MyFile);
            for i in integer range 1 .. SIZE_GENERATION loop
               Put(File => MyFile, Item => "Request table: ");
               Put( File => MyFile, Item => Duration'Image(InTimeRequest(j, i) - FIX_START_TIME));
               New_Line(File => MyFile);
               Put(File => MyFile, Item => "  Getting from table start: ");
               Put( File => MyFile, Item => Duration'Image(InWaitSmoker(j,i) - FIX_START_TIME));
               New_Line(File => MyFile);
               Put(File => MyFile, Item => "  Getting from table stop: ");
               Put( File => MyFile, Item => Duration'Image(OutWaitSmoker(j,i) - FIX_START_TIME));
               New_Line(File => MyFile);
               Put(File => MyFile, Item => "Response table: ");
               Put( File => MyFile, Item => Duration'Image(OutTimeResponse(j, i) - FIX_START_TIME));
               Put(File => MyFile, Item => ";    ");
               New_Line(File => Myfile);
            end loop;
            New_Line(File => MyFile);
            New_Line(File => MyFile);
         end loop;
      Close(MyFile); 

   end Tsmoker;

   task body Tagent is
   begin
      for I in Integer range 1 .. SIZE_GENERATION loop
         OutWaitAgent(4, I) := Seconds(Clock);
         IntimeRequest(4, I) := Seconds(Clock);
         Table.Isempty;
         OuttimeResponse(4, I) := Seconds(Clock);
         InWaitAgent(4, I) := Seconds(Clock);
      end loop;

      Open(File => Myfile, Mode => Append_File,Name => "Log.txt");
      Put(File => Myfile, Item => "Agent");
      for I in Integer range 1 .. SIZE_GENERATION loop
        New_Line(File => Myfile);
        Put(File => Myfile, Item => "Agent stop wait: ");
        Put(File => Myfile, Item => Duration'Image (OutWaitAgent(4, I) - FIX_START_TIME));
        New_Line(File => Myfile);
        Put(File => Myfile, Item => "  Request to table: ");
        Put(File => Myfile, Item => Duration'Image (IntimeRequest(4, I) - FIX_START_TIME));
     --   Put(File => Myfile, Item => "InInTimeGenerate: ");
       -- Put(File => Myfile, Item => Integer'Image(IsGenerated(i)));
         if (IsGenerated(i) = 1) then
           New_Line(File => Myfile);  
           Put(File => Myfile, Item => "    Start generate: ");
           Put(File => Myfile, Item => Duration'Image (InTimeGenerate(1,i) - FIX_START_TIME));
           New_Line(File => Myfile);
           Put(File => Myfile,Item => "     End generate: ");
           Put(File => Myfile,Item => Duration'Image (OutTimeGenerate(1,i) - FIX_START_TIME));
           New_Line(File => Myfile);  
        end if;
        Put(File => Myfile,Item => "  Response from table: ");
        Put(File => Myfile,Item => Duration'Image (OuttimeResponse(4, I) - FIX_START_TIME));
        New_Line(File => Myfile);
        Put(File => Myfile, Item => "Agent start wait: ");
        Put(File => Myfile, Item => Duration'Image (InWaitAgent(4, I) - FIX_START_TIME));
        New_Line(File => Myfile);   
      end loop;
      New_Line(File => Myfile);
      New_Line(File => Myfile);
      Close(Myfile);
      -- ���������� ��� ���������� "������ ��� ������ � ����"
      --      loop
      --      Table.Isempty;
      --   end loop;
   end Tagent;


   task body Tdeck is
      Res : array (Components) of Boolean;  
      -- ������ ����
      procedure Clear_Table is 
      begin
--         Put("Clear table ");
         for I in Res'range loop
            Res(I) := False;
         end loop;
      end Clear_Table;

      -- value 
      Counting : Integer    := 0;  
      V1,V2: Components;  

   begin
      Clear_Table;
      loop
         select
            accept Isempty do begin Counting := 0; 
            COUNT_GENERATION := COUNT_GENERATION + 1;
               for I in Res'range loop
                  if Res(I) = True then
                     Counting := Counting + 1;
                  end if;
               end loop;
               if (Counting = 0) then
                  IsGenerated(COUNT_GENERATION) := 1;
                  InTimeGenerate(1, COUNT_GENERATION) := Seconds(Clock);
                  V1 := Pick_Random(Arr);
                  V2 := Pick_Random(Arr);
                  while V2 = V1 loop
                     V2 := Pick_Random(Arr);
                  end loop;
                  OutTimeGenerate(1, COUNT_GENERATION) := Seconds(Clock);
                else 
                  IsGenerated(COUNT_GENERATION) := 0;
               end if;
            end;
         end Isempty ;
         else
         accept Give (Component1,Component2: out Components ) do 
         begin 
         if (Component1 = V1 ) then if (Component2 = V2 ) then 
               Component1 := V1; 
               Component2 := V2;
               Clear_Table;
         end if;
      end if;
   end;
end Give;
end select;
end loop;
end Tdeck;
begin
   
   Create(File => Myfile,Mode => Out_File, Name => "Log.txt");
   Close(Myfile);
   
   -- write start time
   Open(File => MyFile, Mode => Append_File, Name => "Log.txt");   
   Put(File => Myfile, Item => "StartTime");
   FIX_START_TIME := Seconds(Clock);
   Put(File => Myfile, Item => Duration'Image (FIX_START_TIME));
   New_Line(File => Myfile);
   Close(Myfile);
end SS;