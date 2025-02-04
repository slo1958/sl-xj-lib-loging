#tag Class
Protected Class clDebugLogWriter
Implements itfLogingWriter
	#tag Method, Flags = &h0
		Sub AddLogEntry(MessageSeverity as string, MessageTime as string, MessageSource as string, MessageText as string)
		  // Part of the itfLogingWriter interface.
		  
		  if not self.AcceptedSeverity.Value(MessageSeverity) then Return
		  
		  if MessageSource.Length > 0 then
		    
		    System.DebugLog MessageTime+". " +MessageSeverity + " " +  MessageText + " from " + MessageSource
		    
		  else
		    System.DebugLog MessageTime+". " +MessageSeverity + " " +  MessageText
		    
		  end if
		   
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  self.AcceptedSeverity = new Dictionary
		  
		  Self.AcceptedSeverity.Value(cstSeverityFatalError) = true
		  Self.AcceptedSeverity.Value(cstSeverityError) = true
		  Self.AcceptedSeverity.Value(cstSeverityWarning) = true 
		  self.AcceptedSeverity.Value(cstSeverityInformation) = true
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateSeverityFilter(SeverityLevel as string, AllowOutput as Boolean)
		  
		  
		  self.AcceptedSeverity.Value(SeverityLevel) = AllowOutput
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AcceptedSeverity As Dictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
		#tag ViewProperty
			Name="AcceptedSeverity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
