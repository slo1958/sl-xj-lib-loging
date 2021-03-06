#tag Class
Protected Class clLogingWriterEntry
	#tag Note, Name = read me
		Internal class used by clLoging to store log writer information
		
		
	#tag EndNote


	#tag Property, Flags = &h0
		enabled As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		identity As String
	#tag EndProperty

	#tag Property, Flags = &h0
		log_writer As itfLogingWriter
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="enabled"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="identity"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
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
