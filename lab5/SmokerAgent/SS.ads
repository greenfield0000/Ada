package Ss is

   -- �����������.
   -- 1  -������
   -- 2 - ����� 
   -- 3 - ������
   type Components is 
         (Paper,   
          Tabacco, 
          Match); 
   type Comp_Arr is array (Natural range <>) of Components; 

   task type Tsmoker(Component: Components; Id: INTEGER) is
   end Tsmoker;

   task type Tagent is
   end Tagent;

   task type Tdeck is
      entry Give (Component1,Component2 :out Components ); -- ������ ���������� ����������
      entry Isempty; --�������� �� ������� �����
   end Tdeck;

   function Pick_Random (A : in Comp_Arr ) return Components;

end Ss;