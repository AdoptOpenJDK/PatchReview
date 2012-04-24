PatchReview
===========

Git directory for reviewing warnings fix patches in the openjdk.

Process
=======

1. Add a patch to be reviewed by committing it into the unreviewed directory.
1. Review a patch by moving it to the reviewed directory and writing a comment in the git commit message, comment should either be "Approved" or "2nd opinion requested".  Feel free to make trivial changes if that helps get the patch through (although still note down the author of the patch to tell them what you changed and why).
1. If the patch has already been applied to the OpenJDK codebase by someone else, move it to the beaten directory
1. If the patch is inappropriate for some reason, move it to the rejcted directory with a comment as to why you rejected the patch.

