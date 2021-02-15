#tag Class
Protected Class clLogingMessageEntry
	#tag Method, Flags = &h0
		Sub Constructor(the_message_id as string, the_severity as string, the_message_text as string)
		  message_id = the_message_id
		  message_severity = the_severity
		  message_text = the_message_text
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private message_id As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private message_severity As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private message_text As String
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
