module demos
    ! Demonstrations subroutines

    use forsynth, only: dp, create_WAV_file, PITCH, SEMITONE, finalize_WAV_file
    use signals, only: add_sinusoidal_signal, add_karplus_strong
    use music, only: add_note, add_major_chord, add_minor_chord

    implicit none

    private

    public :: demo1

contains

    subroutine demo1()
        integer  :: i
        real(dp) :: t, delta_t, r
        real(dp) :: f_A, f_C, f_G, f_D
        real(dp) :: chosen_note(0:3)

        print *, "**** Demo 1 ****"
        call create_WAV_file('demo1.wav')

        ! Notes frequencies:
        f_A = PITCH / 2
        f_C = f_A * SEMITONE**(-9)
        f_G = f_A * SEMITONE**(-2)
        f_D = f_C * SEMITONE**(+2)

        ! Notes duration in seconds:
        delta_t = 3.0_dp

        print *, "Track 1: repeating Am C G Dm chords..."
        do i = 0, 9
            t = 4 * delta_t * i ;
            call add_minor_chord(1, t,             t + delta_t,   f_A, 1.0_dp)
            call add_major_chord(1, t + delta_t,   t + 2*delta_t, f_C, 1.0_dp)
            call add_major_chord(1, t + 2*delta_t, t + 3*delta_t, f_G, 1.0_dp)
            call add_minor_chord(1, t + 3*delta_t, t + 4*delta_t, f_D, 1.0_dp)
        end do

        print *, "Track 2: playing random A C G D notes using plucked strings..."
        delta_t = delta_t / 4
        chosen_note(0) = f_A
        chosen_note(1) = f_C
        chosen_note(2) = f_G
        chosen_note(3) = f_D

        do i = 0, 9*16
            t = delta_t * i
            call random_number(r)
            call add_karplus_strong(2, t, t + delta_t, chosen_note(int(r*4)), 1.0_dp)
        end do

        print *, "Final mix..."
        call finalize_WAV_file()
    end subroutine
end module demos
