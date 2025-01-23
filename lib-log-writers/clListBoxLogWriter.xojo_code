#tag Class
Protected Class clListBoxLogWriter
Implements itfLogingWriter
	#tag Method, Flags = &h0
		Sub AddLogEntry(the_severity as string, the_time as string, the_source as string, the_message as string)
		  // Part of the itfLogingWriter interface.
		  
		  If mlb = Nil Then Return
		  
		  mlb.AddRow ""
		  var row_num As Integer = mlb.LastIndex
		  
		  If mlb.ColumnCount >2 Then
		    mlb.cell(row_num, 0 )  = the_time
		    mlb.cell(row_num, 1 )  = the_severity
		    mlb.cell(row_num, 2 )  = the_message
		    
		  Elseif mlb.ColumnCount > 1 Then
		    mlb.cell(row_num, 0 )  = the_time
		    mlb.cell(row_num, 1 )  = the_severity+" "+ the_message
		    
		  Else
		    mlb.cell(row_num, 0 )  = the_time + ". " + the_severity+" "+ the_message
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(the_listbox as Listbox)
		  mlb = the_listbox
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mlb As Listbox
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
