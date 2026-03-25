# Enux Linux

### A Stable Arch‑Based Distribution Built by Students, for Students

---

## Overview

Enux is a lightweight, stable Arch‑based Linux distribution designed specifically for students. The goal is not only to provide a usable operating system, but also to create a structured environment where students can learn Linux development, packaging, performance optimization, and open‑source collaboration.

This repository contains the roadmap, development structure, contribution workflow, and release pipeline for Enux.

---

# Project Vision

Enux focuses on three core principles:

* Stability over bleeding‑edge updates
* Performance on low‑end student hardware
* Education‑focused tools developed by contributors

The distribution is intended to run smoothly on older laptops commonly used by students while still providing a complete programming and study environment.

---

# One‑Year Development Roadmap

The roadmap is divided into four structured phases.

---

## Phase 1 — Foundation 

Goal: Build a minimal and stable Arch‑based ISO

### Main Objectives

* Create repository structure
* Build a minimal ISO using archiso
* Define base package list
* Create installation scripts
* Produce the first bootable prototype

### Phase 1 Roadmap Card

```
┌───────────────────────────────┐
│ Phase 1: Foundation           │
├───────────────────────────────┤
│ Repo structure                │
│ Minimal ISO build             │
│ Base package list             │
│ Installer scripts             │
│ Prototype release             │
└───────────────────────────────┘
```

### Phase 1 Flowchart

```
Start
  │
  ▼
Create GitHub repository
  │
  ▼
Build minimal Arch system
  │
  ▼
Convert to ISO (archiso)
  │
  ▼
Test in VM
  │
  ▼
Fix boot issues
  │
  ▼
Prototype ISO completed
```

---

## Phase 2 — Stability and Performance 

Goal: Convert the prototype into a reliable daily‑use system

### Main Objectives

* Reduce RAM usage
* Optimize boot time
* Remove unnecessary services
* Create a stable package list
* Test on low‑end hardware

### Phase 2 Roadmap Card

```
┌───────────────────────────────┐
│ Phase 2: Stability            │
├───────────────────────────────┤
│ Boot optimization             │
│ RAM optimization              │
│ Service cleanup               │
│ Hardware testing              │
│ Beta ISO                      │
└───────────────────────────────┘
```

### Phase 2 Flowchart

```
Prototype ISO
  │
  ▼
Performance testing
  │
  ▼
Remove unnecessary packages
  │
  ▼
Optimize systemd boot
  │
  ▼
Hardware compatibility testing
  │
  ▼
Stable beta version
```

---

## Phase 3 — Education Features 

Goal: Make Enux unique and student‑focused

### Main Objectives

* Pre‑installed programming tools
* Study mode (distraction‑free desktop)
* Student productivity tools
* Custom educational packages

### Phase 3 Roadmap Card

```
┌───────────────────────────────┐
│ Phase 3: Education Tools      │
├───────────────────────────────┤
│ Programming environment       │
│ Study mode                    │
│ Note‑taking tools             │
│ Student dashboard             │
│ Custom packages               │
└───────────────────────────────┘
```

### Phase 3 Mind Map

```
                     Enux Education Features
                              │
     ┌──────────────┬──────────────┬──────────────┬──────────────┐
     │              │              │              │              │
Study Mode     Programming     Student Tools     Custom Apps   Learning Tools
     │              │              │              │              │
No distractions   Python         Notes           Timer         Offline docs
Focus UI         Git            Tasks           Dashboard      Programming
Website block    C/C++          Study planner   Launcher       Tutorials
```

---

## Phase 4 — Public Release 

Goal: Release a stable distribution and build a student community

### Main Objectives

* Final ISO build
* Full documentation
* Contributor onboarding
* Stable release 1.0

### Phase 4 Roadmap Card

```
┌───────────────────────────────┐
│ Phase 4: Public Release       │
├───────────────────────────────┤
│ Final ISO                     │
│ Documentation                 │
│ GitHub project page           │
│ Contributor onboarding        │
│ Enux 1.0 release              │
└───────────────────────────────┘
```

---

# Repository Structure

```
Enux/
│
├── iso-build/
├── installer/
├── packages/
├── scripts/
├── themes/
├── docs/
├── roadmap/
└── CONTRIBUTING.md
```

---

# Contributor Workflow

This project follows a strict and clean workflow to keep the distribution stable.

---

## Contribution Flowchart

```
Contributor finds issue
        │
        ▼
Create issue (bug / feature / improvement)
        │
        ▼
Maintainer approves issue
        │
        ▼
Contributor creates branch
        │
        ▼
Work on feature / fix
        │
        ▼
Create Pull Request
        │
        ▼
Code review
        │
        ▼
Testing in VM
        │
        ▼
Merge into development branch
```

---

## Branch Structure

```
main        → stable releases only

development → tested features waiting for release

feature/*   → new features
fix/*       → bug fixes
iso/*       → ISO build changes
```

---

## How Students Contribute

Students can contribute in multiple ways:

* Writing installation scripts
* Optimizing performance
* Designing themes
* Testing on old laptops
* Creating educational tools
* Writing documentation

---

# Pull Request Workflow

```
Fork repository
      │
      ▼
Create new branch
      │
      ▼
Make changes
      │
      ▼
Commit using clear messages
      │
      ▼
Push branch
      │
      ▼
Open Pull Request
      │
      ▼
Automated checks run
      │
      ▼
Maintainer review
      │
      ▼
Merge if approved
```

---

# Release Pipeline

The release process is structured to avoid unstable updates.

---

## Release Flowchart

```
Feature completed
      │
      ▼
Merged into development branch
      │
      ▼
Automated ISO build
      │
      ▼
Testing in virtual machines
      │
      ▼
Testing on real hardware
      │
      ▼
Bug fixing phase
      │
      ▼
Release candidate (RC)
      │
      ▼
Final testing
      │
      ▼
Stable release (main branch)
```

---

# Release Types

* Alpha → early prototype
* Beta → mostly stable
* RC (Release Candidate) → ready for final testing
* Stable → official release

---

# Long‑Term Goals

After the first year:

* Custom Enux package repository
* Lightweight custom desktop environment
* Built‑in study dashboard
* Community‑built educational applications

---

# Why Enux Exists

Most Linux distributions are designed for developers or general users. Enux is designed specifically for students who want:

* A fast system on weak hardware
* A distraction‑free study environment
* A ready‑to‑use programming setup
* A project where they can learn real Linux development

---

# How to Join

If you are a student and want to learn:

* Linux
* Programming
* System performance optimization
* Open‑source development

You can contribute directly to this project and learn while buildi

