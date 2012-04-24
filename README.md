PatchReview
===========

Git directory for reviewing warnings fix patches in the openjdk.

Process
=======

1. Add a patch to be reviewed by committing it into the unreviewed directory.
1. Review a patch by moving it to the reviewed directory and writing a comment in the git commit message
1. If the patch has already been applied by someone else, move it to the beaten directory
1. If the patch is inappropriate for some reason, move it to the rejcted directory.

