program test_dict

    use kinds, only: IK, RK
    use errors, only: OK, KEY_NOT_FOUND
    use dict, only: entry_t, get_length, make_entry, dict_t
    implicit none

    type(entry_t) :: e1, e2, e3, e4, e5, e6, e7, e8
    type(dict_t) :: d, d1
    integer(IK) :: error

    if (get_length(1_IK) /= storage_size(1_IK, kind=IK) / 8_IK) stop 1
    if (get_length('a') /= 1_IK) stop 1
    if (get_length('ab') /= 2_IK) stop 1
    if (get_length('abc') /= 3_IK) stop 1
    if (get_length(1.0_RK) /= storage_size(1.0_RK, kind=IK) / 8_IK) stop 1
    if (get_length(.true.) /= storage_size(.true., kind=IK) / 8_IK) stop 1

    e1 = make_entry('integer', 1_IK)
    if (e1%get_key() /= 'integer') stop 1
    if (e1%as_integer() /= 1_IK) stop 1

    e2 = make_entry('string', 'abcd')
    if (e2%get_key() /= 'string') stop 1
    if (e2%as_string() /= 'abcd') stop 1

    e3 = make_entry('real', 1.0_RK)
    if (e3%get_key() /= 'real') stop 1
    if (e3%as_real() /= 1.0_RK) stop 1

    e4 = make_entry('logical', .true.)
    if (e4%get_key() /= 'logical') stop 1
    if (e4%as_logical() .neqv. .true.) stop 1

    e5 = e4
    if (e5%get_key() /= 'logical') stop 1
    if (e5%as_logical() .neqv. .true.) stop 1

    error = d%initialize()
    if (d%count() /= 0_IK) stop 1
    if (d%find_key('a') /= KEY_NOT_FOUND) stop 1

    error = d%put_entry(e1)
    if (error /= OK) stop 1
    if (d%find_key('integer') /= 1_IK) stop 1
    if (d%count() /= 1_IK) stop 1

    e6 = d%retrieve_entry(1_IK)
    if (e6%get_key() /= 'integer') stop 1
    if (e6%as_integer() /= 1_IK) stop 1

    e7 = d%get_entry('integer')
    if (e7%get_key() /= 'integer') stop 1
    if (e7%as_integer() /= 1_IK) stop 1

    e8 = d%get_entry('missing')
    if (e8%get_key() /= 'missing') stop 1
    if (e8%as_string() /= '') stop 1

    if (d%delete('integer') /= OK) stop 1
    if (d%count() /= 0_IK) stop 1
    if (d%find_key('integer') /= KEY_NOT_FOUND) stop 1
    if (d%delete('missing') /= KEY_NOT_FOUND) stop 1

    error = d%put('integer', 2_IK)
    if (error /= OK) stop 1
    if (d%find_key('integer') /= 1_IK) stop 1
    if (d%get_integer('integer') /= 2_IK) stop 1
    if (d%count() /= 1_IK) stop 1

    error = d%put('integer', 3_IK)
    if (d%find_key('integer') /= 1_IK) stop 1
    if (d%get_integer('integer') /= 3_IK) stop 1
    if (d%count() /= 1_IK) stop 1

    error = d%put('another', -1_IK)
    if (error /= OK) stop 1
    if (d%count() /= 2_IK) stop 1
    if (d%find_key('another') /= 1_IK) stop 1
    if (d%find_key('integer') /= 2_IK) stop 1

    error = d%put('string', 'abc')
    if (error /= OK) stop 1
    if (d%count() /= 3_IK) stop 1
    if (d%find_key('string') /= 3_IK) stop 1
    if (d%get_string('string') /= 'abc') stop 1

    error = d%delete('another')
    if (error /= OK) stop 1
    if (d%count() /= 2_IK) stop 1
    if (d%find_key('another') /= KEY_NOT_FOUND) stop 1
    if (d%find_key('integer') /= 1_IK) stop 1
    if (d%find_key('string') /= 2_IK) stop 1

    error = d%put('real', 1.0_RK)
    if (error /= OK) stop 1
    if (d%count() /= 3_IK) stop 1
    if (d%find_key('real') /= 2_IK) stop 1
    if (d%get_real('real') /= 1.0_RK) stop 1

    error = d%put('logical', .true.)
    if (error /= OK) stop 1
    if (d%count() /= 4_IK) stop 1
    if (d%find_key('logical') /= 2_IK) stop 1
    if (d%get_logical('logical') .neqv. .true.) stop 1

    error = d%delete('string')
    if (error /= OK) stop 1
    if (d%count() /= 3_IK) stop 1
    if (d%find_key('logical') /= 2_IK) stop 1

    error = d%delete('logical')
    if (error /= OK) stop 1
    if (d%count() /= 2_IK) stop 1
    if (d%find_key('real') /= 2_IK) stop 1

    d1 = d
    if (d%count() /= 2_IK) stop 1
    if (d%get_integer('integer') /= 3_IK) stop 1
    if (d%get_real('real') /= 1.0_RK) stop 1

    error = d%clear()
    if (error /= OK) stop 1
    if (d%count() /= 0_IK) stop 1

end program test_dict
