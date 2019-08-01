!-----------------------BEGIN NOTICE -- DO NOT EDIT-----------------------
! NASA Goddard Space Flight Center Land Information System (LIS) v7.2
!
! Copyright (c) 2015 United States Government as represented by the
! Administrator of the National Aeronautics and Space Administration.
! All Rights Reserved.
!-------------------------END NOTICE -- DO NOT EDIT-----------------------
!BOP
! !ROUTINE: noahmp36_setsws_hymap2
!  \label{noahmp36_setsws_hymap2}
!
! !REVISION HISTORY:
! 7 Jun 2019: Manabendra Saharia; two-way coupling
!
! !INTERFACE:
subroutine noahmp36_setsws_hymap2(n)
! !USES:
  use ESMF
  use LIS_coreMod, only : LIS_rc, LIS_masterproc
  use LIS_routingMod, only : LIS_runoff_state
  use LIS_logMod
  use LIS_historyMod
  use noahmp36_lsmMod, only : noahmp36_struc

  implicit none
! !ARGUMENTS: 
  integer,  intent(in)   :: n 
!
! !DESCRIPTION:
!  
!
! 
!EOP
  type(ESMF_Field)       :: rivsto_field
  type(ESMF_Field)       :: fldsto_field
  real, pointer          :: rivstotmp(:)
  real, pointer          :: fldstotmp(:)
  integer                :: t
  integer                :: c,r
  integer                :: status
  integer                :: enable2waycpl

  !ms (05June2019)

  call ESMF_AttributeGet(LIS_runoff_state(n),"2 way coupling",&
       enable2waycpl, rc=status)
  call LIS_verify(status)

  if(enable2waycpl) then 
     ! River Storage
     call ESMF_StateGet(LIS_runoff_state(n),"River Storage",&
          rivsto_field,rc=status)
     call LIS_verify(status,'ESMF_StateGet failed for River Storage')
     
     call ESMF_FieldGet(rivsto_field,localDE=0,farrayPtr=rivstotmp,rc=status)
     call LIS_verify(status,'ESMF_FieldGet failed for River Storage')

     !write(LIS_logunit,*) 'rivsto in LIS core', rivstotmp(:)

     ! Flood Storage
     call ESMF_StateGet(LIS_runoff_state(n),"Flood Storage",&
          fldsto_field,rc=status)
     call LIS_verify(status,'ESMF_StateGet failed for Flood Storage')
     
     call ESMF_FieldGet(fldsto_field,localDE=0,farrayPtr=fldstotmp,rc=status)
     call LIS_verify(status,'ESMF_FieldGet failed for Flood Storage')

     !write(LIS_logunit,*) 'fldsto in LIS core', fldstotmp(:)

  endif  

end subroutine noahmp36_setsws_hymap2
