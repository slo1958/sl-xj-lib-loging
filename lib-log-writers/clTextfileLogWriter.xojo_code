#tag Class
Protected Class clTextfileLogWriter
Implements itfLogingWriter
	#tag Method, Flags = &h0
		Sub add_log_entry(the_severity as string, the_time as string, the_source as string, the_message as string)
		  // Part of the itfLogingWriter interface.
		  
		  Using Xojo.IO
		  Using Xojo.Core
		  
		  Dim output As TextOutputStream
		  Try
		    output = TextOutputStream.Append(file_path, TextEncoding.UTF8)
		    Dim tmp_line As String = the_time + field_separator + the_source + field_separator + the_Severity + field_separator + the_message
		    output.WriteLine(tmp_line.totext)
		    output.Close
		    file_error = ""
		    
		  Catch e As IOException
		    file_error = "Error appending to log: "+e.Message
		    
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(the_folder as folderitem = Nil, the_file_name as string, the_time_stamp_place_holder as string="")
		  
		  field_separator = Chr(9)
		  
		  Redim field_names(-1)
		  field_names.Append("When")
		  field_names.Append("Who")
		  field_names.Append("Severity")
		  field_names.Append("Message")
		  
		  If the_file_name.Len > 0 And the_folder <> Nil Then
		    set_file_path(the_folder, the_file_name, the_time_stamp_place_holder)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function get_file_error() As String
		  return file_error
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function get_file_path() As FolderItem
		  Return GetFolderItem(file_path.Path, FolderItem.PathTypeNative)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub set_file_path(the_folder as folderitem, the_file_name as string, the_time_stamp_place_holder as string="")
		  Dim tmp_file_path As FolderItem
		  
		  If the_time_stamp_place_holder.Len > 0 Then
		    Dim tmp_time As String  = Xojo.Core.Date.Now.ToText
		    tmp_time = tmp_time.ReplaceAll("-","")
		    tmp_time = tmp_time.ReplaceAll(":","")
		    tmp_time = tmp_time.ReplaceAll(" ","_")
		    
		    tmp_file_path = the_folder.Child(the_file_name.Replace(the_time_stamp_place_holder, tmp_time))
		    
		  Else
		    tmp_file_path = the_folder.Child(the_file_name)
		    
		  End If
		  
		  file_path = New Xojo.IO.FolderItem(tmp_file_path.NativePath.ToText)
		  
		  
		  Using Xojo.Core
		  Using Xojo.IO
		  
		  Dim output As TextOutputStream
		  Try
		    output = TextOutputStream.Create(file_path, TextEncoding.UTF8)
		    Dim tmp_line As String = field_names(0) + Chr(9) + field_names(1) + Chr(9) + field_names(2) + Chr(9) + field_names(3)
		    output.WriteLine(tmp_line.totext)
		    output.Close
		    file_error = ""
		    
		  Catch e As IOException
		    file_error = "Error creating log file: "+e.Message
		    
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected field_names() As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected field_separator As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private file_error As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private file_path As Xojo.IO.FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
