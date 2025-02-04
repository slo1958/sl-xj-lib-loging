#tag Module
Protected Module lib_loging_constants
	#tag Constant, Name = cDefaultFormatExecutionTime, Type = String, Dynamic = False, Default = \"###\x2C###.000", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cDefaultFormatNumberParam, Type = String, Dynamic = False, Default = \"-####0.000##", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstInternalWriterId, Type = String, Dynamic = False, Default = \"DEFAULT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgErrorMsgDisabled, Type = String, Dynamic = False, Default = \"Error messages disabled.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgReachedErrorLimit, Type = String, Dynamic = False, Default = \"Reached maximum number of errors (set to %0)", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgResetErrorCounter, Type = String, Dynamic = False, Default = \"Reset error counter.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgResetWarningCounter, Type = String, Dynamic = False, Default = \"Reset warning counter.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgSetErrorLimit, Type = String, Dynamic = False, Default = \"Set error limit to %0.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgSetWarningLimit, Type = String, Dynamic = False, Default = \"Set warning limit to %0.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgStatusMessage, Type = String, Dynamic = False, Default = \"Found %0 warning(s)\x2C %1 error(s).", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgTaskEnd, Type = String, Dynamic = False, Default = \"Ending task %0 after %1.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgTaskNotFound, Type = String, Dynamic = False, Default = \"Cannot find task %0\x2C called from %1.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgTaskStart, Type = String, Dynamic = False, Default = \"Starting task %0.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstMsgWarningMsgDisabled, Type = String, Dynamic = False, Default = \"Warning messages disabled.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstSeverityError, Type = String, Dynamic = False, Default = \"ERR", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstSeverityFatalError, Type = String, Dynamic = False, Default = \"FE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstSeverityInformation, Type = String, Dynamic = False, Default = \"INF", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cstSeverityWarning, Type = String, Dynamic = False, Default = \"WNG", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule
