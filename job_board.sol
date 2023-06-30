// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract JobBoard {
    struct User {
        string userId;
        address userAddress;
        string name;
        string phoneNumber;
        bytes32 secretKey; // Hashed secret key
    }

    struct Education {
        uint id;
        string schoolName;
        string courseStudied;
        string qualification;
        string grade;
        string startDate;
        string endDate;
    }
    
    struct Experience {
        uint id;
        string role;
        string companyName;
        string companyLocation;
        string[] description;
    }
    
    struct Certification {
        uint id;
        string title;
        string issuer;
        string qualification;
        string dateIssued;
    }

    struct Applicant {
        string name;
        uint id;
    }

    struct Job {
        uint id;
        string userId;
        string role;
        string companyName;
        string location;
        string jobType;
        uint numberOfApplicants;
        string jobDescription;
        string[] skills;
    }

    uint private counter = 0;  // counter to keep track of the last issued userId

    mapping(address => User) public users;
    mapping(string => string[]) public userSkills;
    mapping(string => Education[]) public userEducation;
    mapping(string => Experience[]) public userExperience;
    mapping(string => Certification[]) public userCertification;
    mapping(uint => Applicant[]) public jobApplicants;

    Job[] public jobs;

    function signUp(address userAddress, string memory name, string memory phoneNumber, bytes32 secretKey) public returns(string memory) {
        require(users[userAddress].userAddress == address(0), "This address has already been used to sign up");

        counter++;  // increment counter

        // Generate userId using the string prefix and the counter
        string memory userId = string(abi.encodePacked("byghyhwksbh2334whb", Strings.toString(counter)));

        User memory newUser = User({
            userId: userId,
            userAddress: userAddress,
            name: name,
            phoneNumber: phoneNumber,
            secretKey: secretKey // Store hashed secret key
        });

        users[userAddress] = newUser;

        return userId;  // return the new userId
    }


    function login(address userAddress, bytes32 secretKey) public view returns (string memory) {
        User memory user = users[userAddress];
        require(user.userAddress != address(0), "Invalid login details");
        require(user.secretKey == secretKey, "Invalid login details");
        return user.userId;
    }

    function addEducation(string memory _userId, Education memory _education) public {
        userEducation[_userId].push(_education);
    }
    
    function removeEducation(string memory _userId, uint _educationId) public {
        delete userEducation[_userId][_educationId];
    }
    
    function addExperience(string memory _userId, Experience memory _experience) public {
        userExperience[_userId].push(_experience);
    }
    
    function removeExperience(string memory _userId, uint _experienceId) public {
        delete userExperience[_userId][_experienceId];
    }

    function addCertification(string memory _userId, Certification memory _certification) public {
        userCertification[_userId].push(_certification);
    }
    
    function removeCertification(string memory _userId, uint _certificationId) public {
        delete userCertification[_userId][_certificationId];
    }

    function createJob(string memory role, string memory companyName, string memory location, string memory jobType, string memory jobDescription, string[] memory skills) public returns(uint) {
        Job memory newJob = Job({
            id: jobs.length,
            userId: users[msg.sender].userId,
            role: role,
            companyName: companyName,
            location: location,
            jobType: jobType,
            numberOfApplicants: 0,
            jobDescription: jobDescription,
            skills: skills
        });

        jobs.push(newJob);
        return jobs.length - 1;
    }

    function deleteJob(uint jobId) public {
        delete jobs[jobId];
    }
    
    function applyToJob(uint jobId, string memory applicantName, uint applicantId) public {
        Applicant memory newApplicant = Applicant(applicantName, applicantId);
        jobApplicants[jobId].push(newApplicant);
        jobs[jobId].numberOfApplicants++;
    }

    function getAllJobs() public view returns (Job[] memory) {
        return jobs;
    }
}
