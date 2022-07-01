exports.root = '0xe8f0179a6e09dcdb53833970baf268481cc624e6188faa83493091c096e34c02';

exports.proofs = [
    {
        address: '0x49CF1782Bb839ACF667313903922A9B26003C28A',
        proof: [
            '0x4012421d196a2370b9cf26c0272acb369140526cac791c4312f32ef7795f7a1d',
            '0x0c151de6f9eb4f267db5858758e2f7edc159f69813ea3a4af5c45c8e641ef99c',
            '0x0c9fe822194e951aadad779df94f20fff765949e8009f8e21381a7824b625de8',
            '0x6762873ae818a418abb92c70ff09e5c2e7e5a3d9c1c5b6f65a380d575db51c8f',
            '0x1153e8e8d0ff8680d9884914f9594c8797be0eeb5a3ca5e26b4aef11fdee8b41',
            '0x64088d588395075cf97e8b0a85549e3ee60ec389fca69f22a365294b2182782b',
            '0x169c81d53bdc8d9711297dad551dc43f3407ea246b041ee4e1902647aa9b5634',
            '0x302ec34c8eef9d2e4f0c6899c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    },
    {
        address: '0xbce39b0E5711a7FB62aeBcB9A9Fb643b6a428cd6',
        proof: [
            '0x56f4c52f41cf8846d962ad2a999d8d6d2948fac9b51636859a447e68dcaf4e4c',
            '0xceb8996641c48e6f865aa3c74e19d8d9f0de17c66e876799a5ec9a622c7bfeda',
            '0xdbd529f2ef73ec0adedc2ce79e10e4807c3403aefb738eae67630431405609e8',
            '0x944390309b8ce62aca5e3efd692610132b9c5c6ca3d12d7153da9cfd61a6b485',
            '0x61e6d9ca6a0f760c230ceae81be94d6d915bda11ffd650f650be660d4c44367e',
            '0xc8e1cbfbcb2f011ab7f07285cbeb6194659d140e4cb71165e8602929ad663613',
            '0x6f67f65b70c65729bf20a72f04f4dd2a67f9388782f9e2b8c1a56d9bb91d9653',
            '0x302ec34c8eef9d2e4f0c6899c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    },
    {
        address: '0xf7c21B14c116EACC067A9b99CbEd4e0B881FddcA',
        proof: [
            '0x2fa8117a483e59389ba72ee8fb63cf4bf5e6b576cda46a717a9200005987c9b3',
            '0xda62b7ed65ffc499c2aca4246ac61a186a16a2feb5f364c12bd4c9b296d26eaf',
            '0xfa1de1fd6f25723db1ecb050f410901bf992fe17e7caf3cbb5abaa55721c0122',
            '0x84f3ab4783decf457972fa992b38c77a88a88458aa31f7d1ae25910c9accd0e6',
            '0xbad87ec46255585dacbd4420804307e4b41446ac02b2e852609b9aa1f4ceedbb',
            '0x64088d588395075cf97e8b0a85549e3ee60ec389fca69f22a365294b2182782b',
            '0x169c81d53bdc8d9711297dad551dc43f3407ea246b041ee4e1902647aa9b5634',
            '0x302ec34c8eef9d2e4f0c6899c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    }
]

exports.badProofs = [
    // Valid address, invalid proof
    {
        address: '0x49CF1782Bb839ACF667313903922A9B26003C28A',
        proof: [
            '0x4012421d196a2370b9cf26c0272acb369140526cac791c4312f32ef7795f7a1d',
            '0x0c151de6f9eb4f267db5858758e2f7edc159f69813ea3a4af5c45c8e641ef99c',
            '0x0c9fe822194e951aadad779df94f20fff765949e8009f8e21381a7824b625de8',
            '0x6762873ae818a418abb92c70ff09e5c2e7e5a3d9c1c5b6f65a380d575db51c8f',
            '0x1153e8e8d0ff8680d9884914f9594c8797be0eeb5a3ca5e26b4aef11fdee8b41',
            '0x64088d588395075cf97e8b0a85549e3ee60ec389fca69f22a365294b2182782b',
            '0x169c81d53bdc8d9711297dad551dc43f3407ea246b041ee4e1902647aa9b5634',
            '0x302ec34c8eef9d2e4f0c6890c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    },
    // Valid address, invalid proof.
    {
        address: '0xbce39b0E5711a7FB62aeBcB9A9Fb643b6a428cd6',
        proof: [
            '0x56f4c52f41cf8846d962ad2a999d8d6d2948fac9b51636859a447e68dcaf4e4c',
            '0xceb8996641c48e6f865bb3c74e19d8d9f0de17c66e876799a5ec9a622c7bfeda',
            '0xdbd529f2ef73ec0adedc2ce79e10e4807c3403aefb738eae67630431405609e8',
            '0x944390309b8ce62aca5e3efd692610132b9c5c6ca3d12d7153da9cfd61a6b485',
            '0x61e6d9ca6a0f760c230ceae81be94d6d915bda11ffd650f650be660d4c44367e',
            '0xc8e1cbfbcb2f011ab7f07285cbeb6194659d140e4cb71165e8602929ad663613',
            '0x6f67f65b70c65729bf20a72f04f4dd2a67f9388782f9e2b8c1a56d9bb91d9653',
            '0x302ec34c8eef9d2e4f0c6899c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    },
    // Invalid address, valid proof.
    {
        address: '0xF7c21b14c117eacc067a9b99cbeD4e0b881fDdCA',
        proof: [
            '0x2fa8117a483e59389ba72ee8fb63cf4bf5e6b576cda46a717a9200005987c9b3',
            '0xda62b7ed65ffc499c2aca4246ac61a186a16a2feb5f364c12bd4c9b296d26eaf',
            '0xfa1de1fd6f25723db1ecb050f410901bf992fe17e7caf3cbb5abaa55721c0122',
            '0x84f3ab4783decf457972fa992b38c77a88a88458aa31f7d1ae25910c9accd0e6',
            '0xbad87ec46255585dacbd4420804307e4b41446ac02b2e852609b9aa1f4ceedbb',
            '0x64088d588395075cf97e8b0a85549e3ee60ec389fca69f22a365294b2182782b',
            '0x169c81d53bdc8d9711297dad551dc43f3407ea246b041ee4e1902647aa9b5634',
            '0x302ec34c8eef9d2e4f0c6899c99f8cb4526878bafb5b10894bf19c83d21fc9ab'
        ]
    }
]