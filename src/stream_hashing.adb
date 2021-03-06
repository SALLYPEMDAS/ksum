-------------------------------------------------------------------------------
--  Copyright (c) 2017, Daniel King
--  All rights reserved.
--
--  This file is part of ksum.
--
--  ksum is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  ksum is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with ksum.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------
with Hex_Strings;              use Hex_Strings;
with Stream_Byte_Arrays;       use Stream_Byte_Arrays;

package body Stream_Hashing
is

   -------------------
   --  Hash_Stream  --
   -------------------

   procedure Hash_Stream (Stream : in out Ada.Streams.Root_Stream_Type'Class;
                          Buffer : in out Keccak.Types.Byte_Array)
   is
      Ctx    : Hash.Context;
      Length : Natural;

      Digest : Hash.Digest_Type;

   begin
      Hash. Init (Ctx);

      loop
         Read_Byte_Array (Stream, Buffer, Length);

         exit when Length = 0;

         Hash.Update (Ctx, Buffer (Buffer'First .. Buffer'First + (Length - 1)));
      end loop;

      Hash.Final (Ctx, Digest);

      Print_Hex_String (Digest);
   end Hash_Stream;

   --------------------
   --  Check_Stream  --
   --------------------

   procedure Check_Stream (Stream        : in out Ada.Streams.Root_Stream_Type'Class;
                           Buffer        : in out Keccak.Types.Byte_Array;
                           Expected_Hash : in     Keccak.Types.Byte_Array;
                           Result        :    out Diagnostic)
   is
      use type Keccak.Types.Byte_Array;

      Ctx    : Hash.Context;
      Length : Natural;

      Digest : Hash.Digest_Type;

   begin
      if Expected_Hash'Length /= Hash.Digest_Type'Length then
         Result := Format_Error;

      else
         Hash. Init (Ctx);

         loop
            Read_Byte_Array (Stream, Buffer, Length);

            exit when Length = 0;

            Hash.Update (Ctx, Buffer (Buffer'First .. Buffer'First + (Length - 1)));
         end loop;

         Hash.Final (Ctx, Digest);

         if Digest /= Expected_Hash then
            Result := Checksum_Error;
         else
            Result := No_Error;
         end if;
      end if;
   end Check_Stream;

end Stream_Hashing;
