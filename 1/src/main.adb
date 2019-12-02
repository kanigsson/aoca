with Ada.Command_Line;
with Ada.Text_IO;

procedure Main with SPARK_Mode is

   function SP_Get_Line (File : ADa.Text_IO.File_Type) return String
     with Global => null;

   -----------------
   -- SP_Get_Line --
   -----------------

   function SP_Get_Line (File : Ada.Text_IO.File_Type)
                         return String with SPARK_Mode => Off
   is
   begin
      return Ada.Text_IO.Get_Line (File);
   end SP_Get_Line;

   ----------------------
   -- Fuel_Requirement --
   ----------------------

   function Fuel_Requirement (Mass : Integer) return Integer is
      Rest : Integer := Mass / 3 - 2;
      Result : Integer := 0;
   begin
      while Rest > 0 loop
         Result := Result + Rest;
         Rest := Rest / 3 - 2;
      end loop;
      return Result;
   end Fuel_Requirement;

   File : Ada.Text_IO.File_Type;
   Sum : Integer := 0;
begin

   Ada.Text_IO.Open (File => File,
         Mode => Ada.Text_IO.In_File,
         Name => Ada.Command_Line.Argument (1));
   while not Ada.Text_IO.End_Of_File (File) Loop
      declare
         Line : constant String := SP_Get_Line (File);
      begin
         Sum := Sum + Fuel_Requirement (Integer'Value (Line));
      end;
   end loop;

   Ada.Text_IO.Close (File);
   Ada.Text_IO.Put_Line (Integer'Image (Sum));
end Main;
