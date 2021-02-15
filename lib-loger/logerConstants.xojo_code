#tag Module
Protected Module logerConstants
	#tag Constant, Name = cst_internal_writer_id, Type = String, Dynamic = False, Default = \"DEFAULT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_error_counter_reset, Type = String, Dynamic = False, Default = \"Error counter reset.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_error_msg_disabled, Type = String, Dynamic = False, Default = \"Error messages disabled.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_status_message, Type = String, Dynamic = False, Default = \"Found %0 warning(s)\x2C %1 error(s).", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_task_end, Type = String, Dynamic = False, Default = \"Ending task %0 after %1.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_task_not_found, Type = String, Dynamic = False, Default = \"Cannot find task %0\x2C called from %1.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_task_start, Type = String, Dynamic = False, Default = \"Starting task %0.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_warning_counter_reset, Type = String, Dynamic = False, Default = \"Warning counter reset.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_msg_warning_msg_disabled, Type = String, Dynamic = False, Default = \"Warning messages disabled.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_severitty_warning, Type = String, Dynamic = False, Default = \"WNG", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_severity_error, Type = String, Dynamic = False, Default = \"ERR", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cst_severity_information, Type = String, Dynamic = False, Default = \"INF", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule
