<?php

namespace spec\App\Rules\Character;

use App\Rules\Character\Character;
use PhpSpec\ObjectBehavior;

class CharacterSpec extends ObjectBehavior
{
    function it_is_initializable(): void
    {
        $this->shouldHaveType(Character::class);
    }
}
