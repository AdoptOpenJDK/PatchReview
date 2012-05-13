PatchReview
===========

Git directory for reviewing warnings fix patches in the openjdk.

Process
=======

1. Fork the main repository (AdoptOpenJDK/PatchReview)
1. Patches to be reviewed should be committed to the unreviewed directory.
1. Review a patch, following the guidelines at http://www.java.net/jugs/AdoptOpenJDK/<appropriate sub project>
1. Feel free to make trivial changes if that helps get the patch through (although still note down the author of the patch to tell them what you changed and why).
1. If approbed, move the reviewed patch to the reviewed directory
1. If the patch has already been applied to the OpenJDK codebase by someone else, move it to the beaten directory
1. If the patch is inappropriate for some reason, move it to the rejected directory with a comment as to why you rejected the patch.
1. Commit, writing a comment in the git commit message, comment should either be "Approved" or "2nd opinion requested".
1. If you need a second review on a patch then put it in the 'further\_review\_needed' directory
1. Rinse and repeat per patch (you can group patch reviews in a single commit, but make sure that this is grouped sensibly, try to to mix rejected with approved etc)
1. Submit a pull request so that someone else can double check your work
