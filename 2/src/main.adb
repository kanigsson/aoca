with Ada.Command_Line;
with Ada.Containers;
with Ada.Containers.Vectors;
with Ada.Directories;
with Ada.Integer_Text_IO;
with Ada.Text_IO;

procedure Main is

   type Board is array (Integer range <>) of Integer;

   package IntVec is new Ada.Containers.Vectors (Index_Type => Natural,
                                                 Element_Type => Integer);

   function Read_State (Filename : String) return Board is
      use Ada.Text_IO;
      use Ada.Containers;


      My_Vec : IntVec.Vector;
      File : File_Type;
   begin
      Ada.Text_IO.Open (File, In_File, Filename);
      while not End_Of_File (File) loop
         declare
            X : Integer;
            C : Character;
            pragma Unreferenced (C);
         begin
            Ada.Integer_Text_IO.Get (File, X);
            My_Vec.Append (X, Count => 1);
            if not End_Of_File (File) then
               Get (File, C);
            end if;
         end;
      end loop;
      declare
         Res : Board (0 .. Integer (My_Vec.Length) - 1);
         Index : Integer := 0;
      begin
         for Elt of My_Vec loop
            Res (Index) := Elt;
            Index := Index + 1;
         end loop;
         return Res;
      end;
   end Read_State;

   procedure Play (State : in out Board) is
      Cur : Natural := 0;
   begin
      loop
         case State (Cur) is
         when 99 =>
            return;
         when 1 =>
            State (State (Cur + 3)) := State (State (Cur + 1)) +
              State (State (Cur + 2));
            Cur := Cur + 4;
         when 2 =>
            State (State (Cur + 3)) := State (State (Cur + 1)) *
              State (State (Cur + 2));
            Cur := Cur + 4;
         when others =>
            raise Program_Error;
         end case;
      end loop;
   end Play;

   File : Ada.Text_IO.File_Type;
begin
   if Ada.Command_Line.Argument_Count < 1 then
      return;
   end if;
   declare
      State : Board := Read_State (Ada.Command_Line.Argument (1));
   begin
      Ada.Text_IO.Put_Line ("playing with" & Integer'Image (State'Length) &
                              " cells");
      pragma Assert (State'First = 0);
      State (1) := 12;
      State (2) := 02;
      Play (State);
      Ada.Text_IO.Put_Line (Integer'Image (State (0)));
   end;
end Main;
