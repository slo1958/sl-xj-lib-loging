#tag Class
Protected Class clLogerTimer
	#tag Method, Flags = &h0
		Sub Constructor(the_task_id as string)
		  identifier = the_task_id
		  start_time = Xojo.Core.Date.Now
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Done()
		  end_time = Xojo.Core.Date.Now
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function get_execution_time() As double
		  Dim interval As Xojo.Core.DateInterval
		  interval = end_time - start_time
		  
		  Dim tmp_ret As Int64 = interval.nanoseconds
		  
		  Return tmp_ret / 100000000
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		end_time As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h0
		identifier As String
	#tag EndProperty

	#tag Property, Flags = &h0
		start_time As Xojo.Core.Date
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
